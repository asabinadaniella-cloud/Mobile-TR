from io import BytesIO

from dataclasses import dataclass, field
from datetime import datetime
from io import BytesIO

import pytest
from fastapi import UploadFile

import tochka_rosta_api.app.services.file as file_module
from tochka_rosta_api.app.services.file import FileService
from tochka_rosta_api.tests.conftest import FakeS3Storage


@dataclass
class StubStoredFile:
    owner_id: int
    filename: str
    content_type: str
    size: int
    bucket: str
    key: str
    id: int = 0
    created_at: datetime = field(default_factory=datetime.utcnow)
    updated_at: datetime = field(default_factory=datetime.utcnow)


file_module.StoredFile = StubStoredFile  # type: ignore[attr-defined]


class DummySession:
    async def commit(self) -> None:  # pragma: no cover - simple stub
        return None

    async def refresh(self, instance: StubStoredFile) -> None:  # pragma: no cover - simple stub
        return None


class DummyFileRepository:
    def __init__(self) -> None:
        self.items: list[StubStoredFile] = []
        self.counter = 0

    async def add(self, stored: StubStoredFile) -> StubStoredFile:
        self.counter += 1
        stored.id = self.counter
        timestamp = datetime.utcnow()
        stored.created_at = timestamp
        stored.updated_at = timestamp
        self.items.append(stored)
        return stored

    async def get(self, file_id: int) -> StubStoredFile | None:
        for stored in self.items:
            if stored.id == file_id:
                return stored
        return None


@pytest.mark.asyncio
async def test_upload_file_success(storage: FakeS3Storage) -> None:
    session = DummySession()
    service = FileService(session, storage=storage)
    service.file_repo = DummyFileRepository()
    upload = UploadFile(
        filename="resume.pdf",
        file=BytesIO(b"%PDF-1.4"),
        headers={"content-type": "application/pdf"},
    )

    result = await service.upload(owner_id=1, upload=upload)

    assert result.filename == "resume.pdf"
    assert result.content_type == "application/pdf"
    assert any(key.endswith("resume.pdf") for key in storage.uploaded.keys())


@pytest.mark.asyncio
async def test_get_file_returns_presigned_url() -> None:
    storage = FakeS3Storage()
    session = DummySession()
    service = FileService(session, storage=storage)
    repository = DummyFileRepository()
    service.file_repo = repository
    upload = UploadFile(
        filename="resume.pdf",
        file=BytesIO(b"%PDF-1.4"),
        headers={"content-type": "application/pdf"},
    )

    stored = await service.upload(owner_id=5, upload=upload)
    fetched = await service.get(stored.id, owner_id=5)
    url = service.get_download_url(fetched)

    assert url.startswith("https://fake-s3/")
