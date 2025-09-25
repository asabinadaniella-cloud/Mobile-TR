from datetime import datetime
from typing import Literal

from pydantic import BaseModel

from .base import ORMBase


ReportStatus = Literal["new", "in_review", "approved", "rejected"]


class ReportCreate(BaseModel):
    response_id: int
    summary: str | None = None


class ReportUpdate(BaseModel):
    status: ReportStatus | None = None
    summary: str | None = None


class ReportRead(ORMBase):
    id: int
    response_id: int
    user_id: int
    status: ReportStatus
    summary: str | None
    created_at: datetime
    updated_at: datetime
