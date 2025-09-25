from sqlalchemy import Boolean, ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base, TimestampMixin


class SurveyVersion(TimestampMixin, Base):
    __tablename__ = "survey_versions"

    id: Mapped[int] = mapped_column(primary_key=True)
    title: Mapped[str] = mapped_column(String(255))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)

    sections = relationship("SurveySection", back_populates="version", cascade="all, delete-orphan")
    responses = relationship("Response", back_populates="survey_version")


class SurveySection(TimestampMixin, Base):
    __tablename__ = "survey_sections"

    id: Mapped[int] = mapped_column(primary_key=True)
    version_id: Mapped[int] = mapped_column(ForeignKey("survey_versions.id", ondelete="CASCADE"))
    title: Mapped[str] = mapped_column(String(255))
    order: Mapped[int] = mapped_column(Integer)

    version = relationship("SurveyVersion", back_populates="sections")
    questions = relationship("SurveyQuestion", back_populates="section", cascade="all, delete-orphan")


class SurveyQuestion(TimestampMixin, Base):
    __tablename__ = "survey_questions"

    id: Mapped[int] = mapped_column(primary_key=True)
    section_id: Mapped[int] = mapped_column(ForeignKey("survey_sections.id", ondelete="CASCADE"))
    text: Mapped[str] = mapped_column(String)
    question_type: Mapped[str] = mapped_column(String(50))
    order: Mapped[int] = mapped_column(Integer)

    section = relationship("SurveySection", back_populates="questions")
    answers = relationship("ResponseAnswer", back_populates="question")
