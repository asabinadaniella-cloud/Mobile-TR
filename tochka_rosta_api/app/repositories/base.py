from typing import Any, Generic, Sequence, TypeVar

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession


ModelType = TypeVar("ModelType")


class BaseRepository(Generic[ModelType]):
    def __init__(self, session: AsyncSession, model: type[ModelType]):
        self.session = session
        self.model = model

    async def get(self, obj_id: Any) -> ModelType | None:
        result = await self.session.execute(select(self.model).where(self.model.id == obj_id))
        return result.scalar_one_or_none()

    async def list(self, **filters: Any) -> Sequence[ModelType]:
        stmt = select(self.model)
        for attr, value in filters.items():
            stmt = stmt.where(getattr(self.model, attr) == value)
        result = await self.session.execute(stmt)
        return result.scalars().all()

    async def add(self, instance: ModelType) -> ModelType:
        self.session.add(instance)
        await self.session.flush()
        return instance

    async def delete(self, instance: ModelType) -> None:
        await self.session.delete(instance)
