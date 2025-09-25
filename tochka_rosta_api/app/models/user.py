from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base, TimestampMixin


class User(TimestampMixin, Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    password_hash: Mapped[str] = mapped_column(String(255))
    full_name: Mapped[str | None] = mapped_column(String(255), nullable=True)
    role: Mapped[str] = mapped_column(String(50), default="user")

    responses = relationship("Response", back_populates="user")
    reports = relationship("Report", back_populates="user")
    chats = relationship("Chat", back_populates="owner")
    files = relationship("StoredFile", back_populates="owner")
    push_tokens = relationship("PushToken", back_populates="user")
