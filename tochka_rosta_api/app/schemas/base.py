from datetime import datetime
from pydantic import BaseModel


class ORMBase(BaseModel):
    class Config:
        from_attributes = True


class Timestamped(ORMBase):
    created_at: datetime
    updated_at: datetime
