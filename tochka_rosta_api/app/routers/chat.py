from fastapi import APIRouter, Depends, Path, status
from sqlalchemy.ext.asyncio import AsyncSession

from ..core.database import get_session
from ..core.security import get_current_user
from ..models.user import User
from ..schemas.chat import ChatCreate, ChatRead, MessageCreate, MessageRead
from ..services.chat import ChatService

router = APIRouter(prefix="/chat", tags=["chat"])


@router.get("", response_model=list[ChatRead])
async def list_chats(
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> list[ChatRead]:
    service = ChatService(session)
    return await service.list_for_user(current_user.id)


@router.post("", response_model=ChatRead, status_code=status.HTTP_201_CREATED)
async def create_chat(
    payload: ChatCreate,
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> ChatRead:
    service = ChatService(session)
    return await service.create(current_user.id, payload)


@router.get("/{chat_id}/messages", response_model=list[MessageRead])
async def list_messages(
    chat_id: int = Path(..., ge=1),
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> list[MessageRead]:
    service = ChatService(session)
    return await service.list_messages(chat_id, current_user.id)


@router.post("/{chat_id}/messages", response_model=MessageRead, status_code=status.HTTP_201_CREATED)
async def send_message(
    payload: MessageCreate,
    chat_id: int = Path(..., ge=1),
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> MessageRead:
    service = ChatService(session)
    return await service.add_message(chat_id, current_user.id, payload)
