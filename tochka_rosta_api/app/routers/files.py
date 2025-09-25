from fastapi import APIRouter, Depends, HTTPException, UploadFile, status
from fastapi.responses import FileResponse
from sqlalchemy.ext.asyncio import AsyncSession

from ..core.database import get_session
from ..core.security import get_current_user
from ..models.user import User
from ..schemas.file import FileRead
from ..services.file import FileService

router = APIRouter(prefix="/files", tags=["files"])


@router.post("/upload", response_model=FileRead, status_code=status.HTTP_201_CREATED)
async def upload_file(
    file: UploadFile,
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> FileRead:
    service = FileService(session)
    return await service.upload(current_user.id, file)


@router.get("/{file_id}")
async def get_file(
    file_id: int,
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
):
    service = FileService(session)
    try:
        stored = await service.get(file_id, current_user.id)
    except FileNotFoundError as exc:  # noqa: PERF203
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="File not found") from exc
    return FileResponse(stored.path, media_type=stored.content_type, filename=stored.filename)
