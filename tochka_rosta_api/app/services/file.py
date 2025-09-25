from __future__ import annotations

import mimetypes
from uuid import uuid4

from fastapi import UploadFile
from sqlalchemy.ext.asyncio import AsyncSession

from ..repositories.file import FileRepository
from ..schemas.file import FileRead
from ..models.file import StoredFile
from ..files.storage.s3 import S3Storage

ALLOWED_CONTENT_TYPES = {
    "application/pdf",
    "application/msword",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
}
MAX_FILE_SIZE = 10 * 1024 * 1024  # 10 MB


class FileService:
    def __init__(self, session: AsyncSession, storage: S3Storage | None = None):
        self.session = session
        self.file_repo = FileRepository(session)
        self.storage = storage or S3Storage()

    async def upload(self, owner_id: int, upload: UploadFile) -> FileRead:
        filename = upload.filename or "file"
        contents = await upload.read()
        await upload.close()

        size = len(contents)
        if size > MAX_FILE_SIZE:
            raise ValueError("File is too large")

        content_type = upload.content_type
        if not content_type:
            guessed, _ = mimetypes.guess_type(filename)
            content_type = guessed or "application/octet-stream"

        if content_type not in ALLOWED_CONTENT_TYPES:
            raise ValueError("Unsupported file type")

        key = f"{owner_id}/{uuid4().hex}_{filename}"
        self.storage.upload(contents, key, content_type)

        stored = StoredFile(
            owner_id=owner_id,
            filename=filename,
            content_type=content_type,
            size=size,
            bucket=self.storage.bucket,
            key=key,
        )
        await self.file_repo.add(stored)
        await self.session.commit()
        await self.session.refresh(stored)
        return FileRead.model_validate(stored)

    async def get(self, file_id: int, owner_id: int) -> StoredFile:
        stored = await self.file_repo.get(file_id)
        if not stored or stored.owner_id != owner_id:
            raise FileNotFoundError
        return stored

    def get_download_url(self, stored: StoredFile, expires_in: int = 3600) -> str:
        return self.storage.generate_presigned_url(stored.key, expires_in)
