from fastapi import APIRouter, Depends, HTTPException, Path, status
from sqlalchemy.ext.asyncio import AsyncSession

from ..core.database import get_session
from ..core.security import get_current_user
from ..models.user import User
from ..schemas.response import ResponseCreate, ResponseRead, ResponseUpdate
from ..services.response import ResponseService

router = APIRouter(prefix="/responses", tags=["responses"])


@router.get("", response_model=list[ResponseRead])
async def list_responses(
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> list[ResponseRead]:
    service = ResponseService(session)
    return await service.list_for_user(current_user.id)


@router.post("", response_model=ResponseRead, status_code=status.HTTP_201_CREATED)
async def create_response(
    payload: ResponseCreate,
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> ResponseRead:
    service = ResponseService(session)
    return await service.create(current_user.id, payload)


@router.put("/{response_id}", response_model=ResponseRead)
async def update_response(
    payload: ResponseUpdate,
    response_id: int = Path(..., ge=1),
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> ResponseRead:
    service = ResponseService(session)
    return await service.update(response_id, current_user.id, payload)
