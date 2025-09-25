from fastapi import HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from ..repositories.chat import ChatRepository, MessageRepository
from ..schemas.chat import ChatCreate, ChatRead, MessageCreate, MessageRead


class ChatService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self.chat_repo = ChatRepository(session)
        self.message_repo = MessageRepository(session)

    async def list_for_user(self, owner_id: int) -> list[ChatRead]:
        chats = await self.chat_repo.list_for_user(owner_id)
        return [ChatRead.model_validate(chat) for chat in chats]

    async def create(self, owner_id: int, payload: ChatCreate) -> ChatRead:
        from ..models.chat import Chat

        chat = Chat(owner_id=owner_id, participant_id=payload.participant_id)
        await self.chat_repo.add(chat)
        await self.session.commit()
        await self.session.refresh(chat)
        return ChatRead.model_validate(chat)

    async def get(self, chat_id: int, user_id: int) -> ChatRead:
        chat = await self.chat_repo.get(chat_id)
        if not chat or (chat.owner_id != user_id and chat.participant_id != user_id):
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Chat not found")
        return ChatRead.model_validate(chat)

    async def list_messages(self, chat_id: int, user_id: int) -> list[MessageRead]:
        await self.get(chat_id, user_id)
        messages = await self.message_repo.list_for_chat(chat_id)
        return [MessageRead.model_validate(msg) for msg in messages]

    async def add_message(self, chat_id: int, user_id: int, payload: MessageCreate) -> MessageRead:
        await self.get(chat_id, user_id)
        from ..models.chat import Message

        message = Message(chat_id=chat_id, sender_id=user_id, content=payload.content)
        await self.message_repo.add(message)
        await self.session.commit()
        await self.session.refresh(message)
        return MessageRead.model_validate(message)
