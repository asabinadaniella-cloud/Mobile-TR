from pathlib import Path

from fastapi import UploadFile
from sqlalchemy.ext.asyncio import AsyncSession

from ..core.config import get_settings
from ..repositories.file import FileRepository
from ..schemas.file import FileRead
from ..models.file import StoredFile

settings = get_settings()


class FileService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self.file_repo = FileRepository(session)
        Path(settings.file_storage_dir).mkdir(parents=True, exist_ok=True)

    async def upload(self, owner_id: int, upload: UploadFile) -> FileRead:
        filename = upload.filename or "file"
        file_path = Path(settings.file_storage_dir) / filename
        counter = 1
        while file_path.exists():
            file_path = Path(settings.file_storage_dir) / f"{counter}_{filename}"
            counter += 1

        contents = await upload.read()
        await upload.close()

        with open(file_path, "wb") as buffer:
            buffer.write(contents)

        from ..models.file import StoredFile

        stored = StoredFile(
            owner_id=owner_id,
            filename=filename,
            content_type=upload.content_type or "application/octet-stream",
            path=str(file_path),
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
