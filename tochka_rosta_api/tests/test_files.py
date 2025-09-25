import asyncio
from collections.abc import AsyncIterator
from typing import Generator

import pytest
from fastapi import Depends
from fastapi.testclient import TestClient
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

from tochka_rosta_api.app.core.database import get_session
from tochka_rosta_api.app.core.security import get_current_user
from tochka_rosta_api.app.main import app
from tochka_rosta_api.app.models.base import Base
from tochka_rosta_api.app.models.user import User
from tochka_rosta_api.app.routers.files import get_file_service
from tochka_rosta_api.app.services.file import FileService


class FakeS3Storage:
    def __init__(self) -> None:
        self.bucket = "test-bucket"
        self.uploaded: dict[str, dict[str, object]] = {}

    def upload(self, data: bytes, key: str, content_type: str) -> None:
        self.uploaded[key] = {"data": data, "content_type": content_type}

    def generate_presigned_url(self, key: str, expires_in: int = 3600) -> str:
        return f"https://fake-s3/{self.bucket}/{key}?expires={expires_in}"


@pytest.fixture(scope="session")
def event_loop() -> Generator[asyncio.AbstractEventLoop, None, None]:
    loop = asyncio.new_event_loop()
    yield loop
    loop.close()


@pytest.fixture()
def session_factory(
    event_loop: asyncio.AbstractEventLoop,
) -> Generator[async_sessionmaker[AsyncSession], None, None]:
    engine = create_async_engine("sqlite+aiosqlite:///:memory:", future=True)

    async def init_models() -> None:
        async with engine.begin() as conn:
            await conn.run_sync(Base.metadata.create_all)

    event_loop.run_until_complete(init_models())
    factory = async_sessionmaker(engine, expire_on_commit=False)
    yield factory
    event_loop.run_until_complete(engine.dispose())


@pytest.fixture()
def storage() -> FakeS3Storage:
    return FakeS3Storage()


@pytest.fixture()
def test_user(session_factory: async_sessionmaker[AsyncSession], event_loop: asyncio.AbstractEventLoop) -> User:
    async def create_user() -> User:
        async with session_factory() as session:
            user = User(email="test@example.com", password_hash="hash", role="user")
            session.add(user)
            await session.commit()
            await session.refresh(user)
            return user

    return event_loop.run_until_complete(create_user())


@pytest.fixture()
def client(
    session_factory: async_sessionmaker[AsyncSession],
    storage: FakeS3Storage,
    test_user: User,
) -> Generator[TestClient, None, None]:
    async def override_get_session() -> AsyncIterator[AsyncSession]:
        async with session_factory() as session:
            yield session

    async def override_get_current_user() -> User:
        return test_user

    def override_get_file_service(
        session: AsyncSession = Depends(get_session),
    ) -> FileService:
        return FileService(session, storage=storage)

    app.dependency_overrides[get_session] = override_get_session
    app.dependency_overrides[get_current_user] = override_get_current_user
    app.dependency_overrides[get_file_service] = override_get_file_service

    with TestClient(app) as test_client:
        yield test_client

    app.dependency_overrides.clear()


def test_upload_file_success(client: TestClient, storage: FakeS3Storage) -> None:
    response = client.post(
        "/files/upload",
        files={"file": ("resume.pdf", b"%PDF-1.4", "application/pdf")},
    )
    assert response.status_code == 201
    data = response.json()
    assert data["filename"] == "resume.pdf"
    assert data["content_type"] == "application/pdf"
    assert any(key.endswith("resume.pdf") for key in storage.uploaded.keys())


def test_get_file_returns_presigned_url(client: TestClient) -> None:
    upload_response = client.post(
        "/files/upload",
        files={"file": ("resume.pdf", b"%PDF-1.4", "application/pdf")},
    )
    file_id = upload_response.json()["id"]

    download_response = client.get(f"/files/{file_id}")
    assert download_response.status_code == 200
    payload = download_response.json()
    assert payload["url"].startswith("https://fake-s3/")
