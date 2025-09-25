from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from ..core.database import get_session
from ..schemas.auth import LoginRequest, RefreshRequest, TokenResponse
from ..schemas.user import UserCreate
from ..services.auth import AuthService

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/register", response_model=TokenResponse)
async def register(payload: UserCreate, session: AsyncSession = Depends(get_session)) -> TokenResponse:
    service = AuthService(session)
    return await service.register(payload)


@router.post("/login", response_model=TokenResponse)
async def login(payload: LoginRequest, session: AsyncSession = Depends(get_session)) -> TokenResponse:
    service = AuthService(session)
    return await service.authenticate(payload.email, payload.password)


@router.post("/refresh", response_model=TokenResponse)
async def refresh(payload: RefreshRequest, session: AsyncSession = Depends(get_session)) -> TokenResponse:
    service = AuthService(session)
    return await service.refresh(payload.refresh_token)
