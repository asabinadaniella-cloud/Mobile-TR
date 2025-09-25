from datetime import datetime

from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from ..models.response import Response as ResponseModel, ResponseAnswer as ResponseAnswerModel
from ..repositories.response import ResponseAnswerRepository, ResponseRepository
from ..schemas.response import ResponseAnswer, ResponseCreate, ResponseRead, ResponseUpdate


class ResponseService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self.response_repo = ResponseRepository(session)
        self.answer_repo = ResponseAnswerRepository(session)

    async def list_for_user(self, user_id: int) -> list[ResponseRead]:
        responses = await self.response_repo.list_by_user(user_id)
        return [self._to_schema(r) for r in responses]

    async def create(self, user_id: int, payload: ResponseCreate) -> ResponseRead:
        response = ResponseModel(user_id=user_id, survey_version_id=payload.survey_version_id)
        await self.response_repo.add(response)
        for ans in payload.answers:
            answer = ResponseAnswerModel(response=response, question_id=ans.question_id, answer=ans.answer)
            await self.answer_repo.add(answer)
        await self.session.commit()
        response = await self.response_repo.get(response.id)
        return self._to_schema(response)

    async def update(self, response_id: int, user_id: int, payload: ResponseUpdate) -> ResponseRead:
        response = await self.response_repo.get(response_id)
        if not response or response.user_id != user_id:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Response not found")

        await self.answer_repo.delete_for_response(response.id)
        for ans in payload.answers:
            answer = ResponseAnswerModel(response_id=response.id, question_id=ans.question_id, answer=ans.answer)
            await self.answer_repo.add(answer)
        response.submitted_at = datetime.utcnow()
        await self.session.commit()
        response = await self.response_repo.get(response.id)
        return self._to_schema(response)

    def _to_schema(self, response: ResponseModel | None) -> ResponseRead:
        if response is None:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Response not found")
        return ResponseRead(
            id=response.id,
            user_id=response.user_id,
            survey_version_id=response.survey_version_id,
            submitted_at=response.submitted_at,
            created_at=response.created_at,
            updated_at=response.updated_at,
            answers=[
                ResponseAnswer(question_id=answer.question_id, answer=answer.answer)
                for answer in response.answers
            ],
        )
