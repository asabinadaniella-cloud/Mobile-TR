from datetime import datetime, timedelta

from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from ..core.config import get_settings
from ..core.security import create_access_token, create_refresh_token, hash_password, verify_password
from ..models.token import RefreshToken
from ..repositories.token import RefreshTokenRepository
from ..repositories.user import UserRepository
from ..schemas.auth import TokenResponse
from ..schemas.user import UserCreate


class AuthService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self.user_repo = UserRepository(session)
        self.refresh_repo = RefreshTokenRepository(session)
        self.settings = get_settings()

    async def register(self, payload: UserCreate) -> TokenResponse:
        existing = await self.user_repo.get_by_email(payload.email)
        if existing:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email already registered")

        from ..models.user import User

        user = User(email=payload.email, password_hash=hash_password(payload.password), full_name=payload.full_name)
        await self.user_repo.add(user)
        await self.session.commit()
        return await self._issue_tokens(user.email, user.id)

    async def authenticate(self, email: str, password: str) -> TokenResponse:
        user = await self.user_repo.get_by_email(email)
        if not user or not verify_password(password, user.password_hash):
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Incorrect credentials")
        return await self._issue_tokens(user.email, user.id)

    async def refresh(self, token: str) -> TokenResponse:
        now = datetime.utcnow()
        refresh = await self.refresh_repo.get_valid(token, now)
        if not refresh:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid refresh token")
        user = await self.user_repo.get(refresh.user_id)
        if not user:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found")
        await self.refresh_repo.delete_user_tokens(user.id)
        await self.session.commit()
        return await self._issue_tokens(user.email, user.id)

    async def _issue_tokens(self, email: str, user_id: int) -> TokenResponse:
        access_token = create_access_token(email)
        refresh_token = create_refresh_token(email)

        expires_at = datetime.utcnow() + timedelta(minutes=self.settings.refresh_token_expire_minutes)
        token_model = RefreshToken(user_id=user_id, token=refresh_token, expires_at=expires_at)
        await self.refresh_repo.add(token_model)
        await self.session.commit()
        return TokenResponse(access_token=access_token, refresh_token=refresh_token)
