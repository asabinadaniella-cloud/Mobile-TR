from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..models.push import PushToken
from .base import BaseRepository


class PushTokenRepository(BaseRepository[PushToken]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, PushToken)

    async def get_by_token(self, token: str) -> PushToken | None:
        result = await self.session.execute(select(PushToken).where(PushToken.token == token))
        return result.scalar_one_or_none()
