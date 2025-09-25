from fastapi import HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from ..repositories.report import ReportRepository
from ..schemas.report import ReportRead, ReportUpdate


class ReportService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self.report_repo = ReportRepository(session)

    async def list_my_reports(self, user_id: int) -> list[ReportRead]:
        reports = await self.report_repo.list_by_user(user_id)
        return [ReportRead.model_validate(r) for r in reports]

    async def get(self, report_id: int) -> ReportRead:
        report = await self.report_repo.get(report_id)
        if not report:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Report not found")
        return ReportRead.model_validate(report)

    async def update(self, report_id: int, payload: ReportUpdate) -> ReportRead:
        report = await self.report_repo.get(report_id)
        if not report:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Report not found")
        if payload.status is not None:
            report.status = payload.status
        if payload.summary is not None:
            report.summary = payload.summary
        await self.session.commit()
        await self.session.refresh(report)
        return ReportRead.model_validate(report)
