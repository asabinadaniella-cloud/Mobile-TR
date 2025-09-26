from __future__ import annotations

import pytest


class FakeS3Storage:
    def __init__(self) -> None:
        self.bucket = "test-bucket"
        self.uploaded: dict[str, dict[str, object]] = {}

    def upload(self, data: bytes, key: str, content_type: str) -> None:
        self.uploaded[key] = {"data": data, "content_type": content_type}

    def generate_presigned_url(self, key: str, expires_in: int = 3600) -> str:
        return f"https://fake-s3/{self.bucket}/{key}?expires={expires_in}"


@pytest.fixture()
def storage() -> FakeS3Storage:
    return FakeS3Storage()
