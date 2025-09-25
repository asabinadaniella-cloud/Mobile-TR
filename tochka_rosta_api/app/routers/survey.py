from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from ..core.database import get_session
from ..schemas.survey import SurveyQuestionRead, SurveySectionRead, SurveyVersionRead
from ..services.survey import SurveyService

router = APIRouter(prefix="/survey", tags=["survey"])


@router.get("/versions", response_model=list[SurveyVersionRead])
async def get_versions(session: AsyncSession = Depends(get_session)) -> list[SurveyVersionRead]:
    service = SurveyService(session)
    return await service.get_active_versions()


@router.get("/sections", response_model=list[SurveySectionRead])
async def get_sections(
    version_id: int = Query(..., description="Survey version identifier"),
    session: AsyncSession = Depends(get_session),
) -> list[SurveySectionRead]:
    service = SurveyService(session)
    return await service.get_sections(version_id)


@router.get("/questions", response_model=list[SurveyQuestionRead])
async def get_questions(
    section_id: int = Query(..., description="Survey section identifier"),
    session: AsyncSession = Depends(get_session),
) -> list[SurveyQuestionRead]:
    service = SurveyService(session)
    return await service.get_questions(section_id)
