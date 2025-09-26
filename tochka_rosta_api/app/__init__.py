"""Application package providing lazy access to the FastAPI app instance."""

from importlib import import_module
from typing import Any

__all__ = ["app"]


def __getattr__(name: str) -> Any:  # pragma: no cover - simple attribute proxy
    if name == "app":
        return import_module(".main", __name__).app
    raise AttributeError(f"module '{__name__}' has no attribute '{name}'")
