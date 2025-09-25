from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..models.chat import Chat, Message
from .base import BaseRepository


class ChatRepository(BaseRepository[Chat]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, Chat)

    async def list_for_user(self, user_id: int) -> list[Chat]:
        stmt = select(Chat).where((Chat.owner_id == user_id) | (Chat.participant_id == user_id))
        result = await self.session.execute(stmt)
        return result.scalars().all()


class MessageRepository(BaseRepository[Message]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, Message)

    async def list_for_chat(self, chat_id: int) -> list[Message]:
        result = await self.session.execute(select(Message).where(Message.chat_id == chat_id))
        return result.scalars().all()
