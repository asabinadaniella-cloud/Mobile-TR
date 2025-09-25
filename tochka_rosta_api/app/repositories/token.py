from datetime import datetime

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..models.token import RefreshToken
from .base import BaseRepository


class RefreshTokenRepository(BaseRepository[RefreshToken]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, RefreshToken)

    async def get_valid(self, token: str, now: datetime) -> RefreshToken | None:
        stmt = select(RefreshToken).where(RefreshToken.token == token, RefreshToken.expires_at >= now)
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def delete_user_tokens(self, user_id: int) -> None:
        await self.session.execute(RefreshToken.__table__.delete().where(RefreshToken.user_id == user_id))
