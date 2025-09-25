from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..models.report import Report
from .base import BaseRepository


class ReportRepository(BaseRepository[Report]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, Report)

    async def list_by_user(self, user_id: int) -> list[Report]:
        result = await self.session.execute(select(Report).where(Report.user_id == user_id))
        return result.scalars().all()
