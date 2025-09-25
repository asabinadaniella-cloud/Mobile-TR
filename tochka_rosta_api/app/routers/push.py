from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from ..core.database import get_session
from ..core.security import get_current_user
from ..models.push import PushToken
from ..models.user import User
from ..schemas.push import PushRegisterRequest
from ..services.push import PushService

router = APIRouter(prefix="/push", tags=["push"])


@router.post("/register", response_model=PushRegisterRequest, status_code=status.HTTP_201_CREATED)
async def register_push(
    payload: PushRegisterRequest,
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> PushRegisterRequest:
    service = PushService(session)
    token: PushToken = await service.register(current_user.id, payload)
    return PushRegisterRequest(token=token.token, device_type=token.device_type)
