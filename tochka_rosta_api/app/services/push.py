from sqlalchemy.ext.asyncio import AsyncSession

from ..models.push import PushToken
from ..repositories.push import PushTokenRepository
from ..schemas.push import PushRegisterRequest


class PushService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self.push_repo = PushTokenRepository(session)

    async def register(self, user_id: int, payload: PushRegisterRequest) -> PushToken:
        existing = await self.push_repo.get_by_token(payload.token)
        if existing:
            existing.user_id = user_id
            existing.device_type = payload.device_type
            await self.session.commit()
            await self.session.refresh(existing)
            return existing

        token = PushToken(user_id=user_id, token=payload.token, device_type=payload.device_type)
        await self.push_repo.add(token)
        await self.session.commit()
        await self.session.refresh(token)
        return token
