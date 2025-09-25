from datetime import datetime

from pydantic import BaseModel

from .base import ORMBase


class FileRead(ORMBase):
    id: int
    owner_id: int
    filename: str
    content_type: str
    size: int
    bucket: str
    key: str
    created_at: datetime
    updated_at: datetime


class FileDownloadResponse(BaseModel):
    url: str
