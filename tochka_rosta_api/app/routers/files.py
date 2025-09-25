from fastapi import APIRouter, Depends, HTTPException, UploadFile, status
from sqlalchemy.ext.asyncio import AsyncSession

from ..core.database import get_session
from ..core.security import get_current_user
from ..models.user import User
from ..schemas.file import FileDownloadResponse, FileRead
from ..services.file import FileService

router = APIRouter(prefix="/files", tags=["files"])


def get_file_service(session: AsyncSession = Depends(get_session)) -> FileService:
    return FileService(session)


@router.post("/upload", response_model=FileRead, status_code=status.HTTP_201_CREATED)
async def upload_file(
    file: UploadFile,
    current_user: User = Depends(get_current_user),
    service: FileService = Depends(get_file_service),
) -> FileRead:
    try:
        return await service.upload(current_user.id, file)
    except ValueError as exc:  # noqa: PERF203
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(exc)) from exc


@router.get("/{file_id}", response_model=FileDownloadResponse)
async def get_file(
    file_id: int,
    current_user: User = Depends(get_current_user),
    service: FileService = Depends(get_file_service),
) -> FileDownloadResponse:
    try:
        stored = await service.get(file_id, current_user.id)
    except FileNotFoundError as exc:  # noqa: PERF203
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="File not found") from exc
    url = service.get_download_url(stored)
    return FileDownloadResponse(url=url)
