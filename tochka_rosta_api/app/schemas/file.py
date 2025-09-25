from datetime import datetime

from .base import ORMBase


class FileRead(ORMBase):
    id: int
    owner_id: int
    filename: str
    content_type: str
    path: str
    created_at: datetime
    updated_at: datetime
