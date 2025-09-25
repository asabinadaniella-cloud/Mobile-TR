from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base, TimestampMixin


class Chat(TimestampMixin, Base):
    __tablename__ = "chats"

    id: Mapped[int] = mapped_column(primary_key=True)
    owner_id: Mapped[int] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"))
    participant_id: Mapped[int | None] = mapped_column(ForeignKey("users.id", ondelete="SET NULL"))

    owner = relationship("User", foreign_keys=[owner_id], back_populates="chats")
    participant = relationship("User", foreign_keys=[participant_id])
    messages = relationship("Message", back_populates="chat", cascade="all, delete-orphan")


class Message(TimestampMixin, Base):
    __tablename__ = "messages"

    id: Mapped[int] = mapped_column(primary_key=True)
    chat_id: Mapped[int] = mapped_column(ForeignKey("chats.id", ondelete="CASCADE"))
    sender_id: Mapped[int] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"))
    content: Mapped[str] = mapped_column(String)

    chat = relationship("Chat", back_populates="messages")
    sender = relationship("User")
