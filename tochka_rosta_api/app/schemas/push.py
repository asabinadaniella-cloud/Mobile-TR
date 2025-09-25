from pydantic import BaseModel


class PushRegisterRequest(BaseModel):
    token: str
    device_type: str | None = None
