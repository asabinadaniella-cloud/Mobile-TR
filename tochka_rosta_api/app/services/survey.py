from sqlalchemy.ext.asyncio import AsyncSession

from ..repositories.survey import (
    SurveyQuestionRepository,
    SurveySectionRepository,
    SurveyVersionRepository,
)
from ..schemas.survey import SurveyQuestionRead, SurveySectionRead, SurveyVersionRead


class SurveyService:
    def __init__(self, session: AsyncSession):
        self.version_repo = SurveyVersionRepository(session)
        self.section_repo = SurveySectionRepository(session)
        self.question_repo = SurveyQuestionRepository(session)

    async def get_active_versions(self) -> list[SurveyVersionRead]:
        versions = await self.version_repo.list_active()
        return [SurveyVersionRead.model_validate(v) for v in versions]

    async def get_sections(self, version_id: int) -> list[SurveySectionRead]:
        sections = await self.section_repo.list(version_id=version_id)
        return [SurveySectionRead.model_validate(s) for s in sections]

    async def get_questions(self, section_id: int) -> list[SurveyQuestionRead]:
        questions = await self.question_repo.list(section_id=section_id)
        return [SurveyQuestionRead.model_validate(q) for q in questions]
