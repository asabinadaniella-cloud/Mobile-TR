from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..models.file import StoredFile
from .base import BaseRepository


class FileRepository(BaseRepository[StoredFile]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, StoredFile)

    async def list_by_owner(self, owner_id: int) -> list[StoredFile]:
        result = await self.session.execute(select(StoredFile).where(StoredFile.owner_id == owner_id))
        return result.scalars().all()
