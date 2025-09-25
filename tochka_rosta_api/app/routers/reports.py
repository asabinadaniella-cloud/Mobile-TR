from fastapi import APIRouter, Depends, Path
from sqlalchemy.ext.asyncio import AsyncSession

from ..core.database import get_session
from ..core.security import get_current_user, require_role
from ..models.user import User
from ..schemas.report import ReportRead, ReportUpdate
from ..services.report import ReportService

router = APIRouter(prefix="/reports", tags=["reports"])


@router.get("", response_model=list[ReportRead])
async def my_reports(
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> list[ReportRead]:
    service = ReportService(session)
    return await service.list_my_reports(current_user.id)


@router.get("/{report_id}", response_model=ReportRead)
@require_role("moderator")
async def get_report(
    report_id: int = Path(..., ge=1),
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> ReportRead:
    service = ReportService(session)
    return await service.get(report_id)


@router.patch("/{report_id}", response_model=ReportRead)
@require_role("moderator")
async def update_report(
    payload: ReportUpdate,
    report_id: int = Path(..., ge=1),
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> ReportRead:
    service = ReportService(session)
    return await service.update(report_id, payload)
