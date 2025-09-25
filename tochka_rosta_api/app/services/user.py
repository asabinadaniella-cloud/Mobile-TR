from sqlalchemy.ext.asyncio import AsyncSession

from ..repositories.user import UserRepository
from ..schemas.user import UserRead


class UserService:
    def __init__(self, session: AsyncSession):
        self.user_repo = UserRepository(session)

    async def get_profile(self, user_id: int) -> UserRead | None:
        user = await self.user_repo.get(user_id)
        return UserRead.model_validate(user) if user else None
