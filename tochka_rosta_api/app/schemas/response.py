from datetime import datetime
from typing import List

from pydantic import BaseModel

from .base import ORMBase


class ResponseAnswer(BaseModel):
    question_id: int
    answer: str


class ResponseCreate(BaseModel):
    survey_version_id: int
    answers: List[ResponseAnswer]


class ResponseUpdate(BaseModel):
    answers: List[ResponseAnswer]


class ResponseRead(ORMBase):
    id: int
    user_id: int
    survey_version_id: int
    submitted_at: datetime | None
    created_at: datetime
    updated_at: datetime
    answers: List[ResponseAnswer]
