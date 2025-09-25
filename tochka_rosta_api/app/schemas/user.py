from datetime import datetime
from pydantic import BaseModel, EmailStr, Field

from .base import ORMBase


class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8)
    full_name: str | None = None


class UserRead(ORMBase):
    id: int
    email: EmailStr
    full_name: str | None
    role: str
    created_at: datetime
    updated_at: datetime
