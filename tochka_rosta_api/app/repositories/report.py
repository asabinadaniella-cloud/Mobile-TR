from sqlalchemy import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession

from ..models.report import Report
from ..models.response import Response
from ..models.response import ResponseAnswer
from .base import BaseRepository


class ReportRepository(BaseRepository[Report]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, Report)

    async def list_by_user(self, user_id: int) -> list[Report]:
        result = await self.session.execute(select(Report).where(Report.user_id == user_id))
        return result.scalars().all()

    async def get_with_details(self, report_id: int) -> Report | None:
        stmt = (
            select(Report)
            .options(
                selectinload(Report.user),
                selectinload(Report.response)
                .selectinload(Response.answers)
                .selectinload(ResponseAnswer.question),
            )
            .where(Report.id == report_id)
        )
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()
