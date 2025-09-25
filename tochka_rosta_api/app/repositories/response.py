from sqlalchemy import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession

from ..models.response import Response, ResponseAnswer
from .base import BaseRepository


class ResponseRepository(BaseRepository[Response]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, Response)

    async def get(self, obj_id: int) -> Response | None:
        stmt = select(Response).options(selectinload(Response.answers)).where(Response.id == obj_id)
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def list_by_user(self, user_id: int) -> list[Response]:
        stmt = select(Response).options(selectinload(Response.answers)).where(Response.user_id == user_id)
        result = await self.session.execute(stmt)
        return result.scalars().all()


class ResponseAnswerRepository(BaseRepository[ResponseAnswer]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, ResponseAnswer)

    async def delete_for_response(self, response_id: int) -> None:
        await self.session.execute(ResponseAnswer.__table__.delete().where(ResponseAnswer.response_id == response_id))
