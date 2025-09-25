from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..models.survey import SurveyQuestion, SurveySection, SurveyVersion
from .base import BaseRepository


class SurveyVersionRepository(BaseRepository[SurveyVersion]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, SurveyVersion)

    async def list_active(self) -> list[SurveyVersion]:
        result = await self.session.execute(select(SurveyVersion).where(SurveyVersion.is_active.is_(True)))
        return result.scalars().all()


class SurveySectionRepository(BaseRepository[SurveySection]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, SurveySection)


class SurveyQuestionRepository(BaseRepository[SurveyQuestion]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, SurveyQuestion)
