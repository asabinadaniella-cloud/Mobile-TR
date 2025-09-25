from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base, TimestampMixin


class Response(TimestampMixin, Base):
    __tablename__ = "responses"

    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"))
    survey_version_id: Mapped[int] = mapped_column(ForeignKey("survey_versions.id", ondelete="CASCADE"))
    submitted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    user = relationship("User", back_populates="responses")
    survey_version = relationship("SurveyVersion", back_populates="responses")
    answers = relationship("ResponseAnswer", back_populates="response", cascade="all, delete-orphan")
    report = relationship("Report", back_populates="response", uselist=False)


class ResponseAnswer(TimestampMixin, Base):
    __tablename__ = "response_answers"

    id: Mapped[int] = mapped_column(primary_key=True)
    response_id: Mapped[int] = mapped_column(ForeignKey("responses.id", ondelete="CASCADE"))
    question_id: Mapped[int] = mapped_column(ForeignKey("survey_questions.id", ondelete="CASCADE"))
    answer: Mapped[str] = mapped_column(String)

    response = relationship("Response", back_populates="answers")
    question = relationship("SurveyQuestion", back_populates="answers")
