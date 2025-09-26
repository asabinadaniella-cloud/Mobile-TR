from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from io import BytesIO

import pytest
from fastapi import UploadFile

import tochka_rosta_api.app.services.file as file_module
from tochka_rosta_api.app.services.file import ALLOWED_CONTENT_TYPES, MAX_FILE_SIZE, FileService
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
async def test_upload_file_persists_metadata(storage: FakeS3Storage) -> None:
    session = DummySession()
    service = FileService(session, storage=storage)
    service.file_repo = DummyFileRepository()
    upload = UploadFile(
        filename="/tmp/uploads/resume.pdf",
        file=BytesIO(b"%PDF-1.4 sample"),
        headers={"content-type": "application/pdf"},
    )

    stored = await service.upload(owner_id=1, upload=upload)

    assert stored.filename == "resume.pdf"
    assert stored.bucket == storage.bucket
    assert stored.size == len(b"%PDF-1.4 sample")
    assert stored.key in storage.uploaded
    assert storage.uploaded[stored.key]["content_type"] == "application/pdf"
    assert service.file_repo.items[0].owner_id == 1


@pytest.mark.asyncio
async def test_upload_rejects_large_file(storage: FakeS3Storage) -> None:
    session = DummySession()
    service = FileService(session, storage=storage)
    service.file_repo = DummyFileRepository()
    upload = UploadFile(
        filename="large.pdf",
        file=BytesIO(b"a" * (MAX_FILE_SIZE + 1)),
        headers={"content-type": "application/pdf"},
    )

    with pytest.raises(ValueError) as exc_info:
        await service.upload(owner_id=2, upload=upload)

    assert "too large" in str(exc_info.value)
    assert storage.uploaded == {}


@pytest.mark.asyncio
async def test_upload_rejects_unsupported_type(storage: FakeS3Storage) -> None:
    session = DummySession()
    service = FileService(session, storage=storage)
    service.file_repo = DummyFileRepository()
    upload = UploadFile(
        filename="malware.exe",
        file=BytesIO(b"MZ"),
        headers={"content-type": "application/octet-stream"},
    )

    with pytest.raises(ValueError) as exc_info:
        await service.upload(owner_id=3, upload=upload)

    assert "Unsupported file type" in str(exc_info.value)
    assert storage.uploaded == {}


@pytest.mark.asyncio
async def test_get_download_url_uses_presigned_link(storage: FakeS3Storage) -> None:
    session = DummySession()
    service = FileService(session, storage=storage)
    repository = DummyFileRepository()
    service.file_repo = repository
    upload = UploadFile(
        filename="contract.docx",
        file=BytesIO(b"PK\x03\x04"),
        headers={
            "content-type": "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        },
    )

    stored = await service.upload(owner_id=4, upload=upload)
    fetched = await service.get(stored.id, owner_id=4)
    url = service.get_download_url(fetched, expires_in=600)

    assert url.startswith("https://fake-s3/")
    assert f"{storage.bucket}/" in url
    assert fetched.content_type in ALLOWED_CONTENT_TYPES
    assert "expires=600" in url


@pytest.mark.asyncio
async def test_get_for_other_owner_raises(storage: FakeS3Storage) -> None:
    session = DummySession()
    service = FileService(session, storage=storage)
    repository = DummyFileRepository()
    service.file_repo = repository
    upload = UploadFile(
        filename="doc.doc",
        file=BytesIO(b"DOC"),
        headers={"content-type": "application/msword"},
    )

    stored = await service.upload(owner_id=5, upload=upload)

    with pytest.raises(FileNotFoundError):
        await service.get(stored.id, owner_id=999)
