from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "tochka_rosta_api"
    debug: bool = False
    database_url: str = "postgresql+asyncpg://user:password@localhost:5432/tochka_rosta"

    jwt_secret_key: str = "CHANGE_ME"
    jwt_refresh_secret_key: str = "CHANGE_ME_REFRESH"
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 15
    refresh_token_expire_minutes: int = 60 * 24 * 7

    cors_origins: list[str] = ["*"]
    rate_limit_requests: int = 100
    rate_limit_window_seconds: int = 60

    file_storage_dir: str = "app/files/storage"

    s3_endpoint: str | None = None
    s3_access_key: str | None = None
    s3_secret_key: str | None = None
    s3_bucket: str = "files"
    s3_region: str | None = None

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")


@lru_cache
def get_settings() -> Settings:
    return Settings()
