"""S3 storage helper utilities."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

import boto3

from ...core.config import get_settings


@dataclass(slots=True)
class S3StorageConfig:
    endpoint_url: str | None
    access_key: str | None
    secret_key: str | None
    bucket: str
    region_name: str | None


class S3Storage:
    """A thin wrapper around boto3 S3 client used by the application."""

    def __init__(self, config: S3StorageConfig | None = None):
        settings = get_settings()
        cfg = config or S3StorageConfig(
            endpoint_url=settings.s3_endpoint,
            access_key=settings.s3_access_key,
            secret_key=settings.s3_secret_key,
            bucket=settings.s3_bucket,
            region_name=settings.s3_region,
        )
        self._config = cfg
        self._client = boto3.client(
            "s3",
            endpoint_url=cfg.endpoint_url,
            aws_access_key_id=cfg.access_key,
            aws_secret_access_key=cfg.secret_key,
            region_name=cfg.region_name,
        )

    @property
    def bucket(self) -> str:
        return self._config.bucket

    @property
    def client(self):
        return self._client

    def upload(self, data: bytes, key: str, content_type: str) -> None:
        extra_args: dict[str, Any] = {"ContentType": content_type}
        self._client.put_object(Bucket=self.bucket, Key=key, Body=data, **extra_args)

    def generate_presigned_url(self, key: str, expires_in: int = 3600) -> str:
        return self._client.generate_presigned_url(
            "get_object",
            Params={"Bucket": self.bucket, "Key": key},
            ExpiresIn=expires_in,
        )
