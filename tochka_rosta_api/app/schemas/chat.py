from datetime import datetime
from pydantic import BaseModel

from .base import ORMBase


class ChatCreate(BaseModel):
    participant_id: int | None = None


class ChatRead(ORMBase):
    id: int
    owner_id: int
    participant_id: int | None
    created_at: datetime
    updated_at: datetime


class MessageCreate(BaseModel):
    content: str


class MessageRead(ORMBase):
    id: int
    chat_id: int
    sender_id: int
    content: str
    created_at: datetime
    updated_at: datetime
