from datetime import datetime
from pydantic import BaseModel

from .base import ORMBase


class SurveyVersionCreate(BaseModel):
    title: str
    is_active: bool = True


class SurveyVersionRead(ORMBase):
    id: int
    title: str
    is_active: bool
    created_at: datetime


class SurveySectionCreate(BaseModel):
    version_id: int
    title: str
    order: int


class SurveySectionRead(ORMBase):
    id: int
    version_id: int
    title: str
    order: int


class SurveyQuestionCreate(BaseModel):
    section_id: int
    text: str
    question_type: str
    order: int


class SurveyQuestionRead(ORMBase):
    id: int
    section_id: int
    text: str
    question_type: str
    order: int
