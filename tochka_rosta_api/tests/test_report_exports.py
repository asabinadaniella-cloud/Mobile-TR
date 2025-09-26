import pytest
from fastapi import HTTPException

from tochka_rosta_api.app.routers import reports
from tochka_rosta_api.app.services.report import ReportService


class DummyUser:
    def __init__(self, user_id: int, email: str, role: str) -> None:
        self.id = user_id
        self.email = email
        self.role = role


class DummyQuestion:
    def __init__(self, question_id: int, text: str, order: int) -> None:
        self.id = question_id
        self.text = text
        self.order = order


class DummyAnswer:
    def __init__(self, question_id: int, answer: str, question: DummyQuestion) -> None:
        self.question_id = question_id
        self.answer = answer
        self.question = question


class DummyResponse:
    def __init__(self, answers: list[DummyAnswer]) -> None:
        self.answers = answers


class DummyReport:
    def __init__(self, report_id: int, owner: DummyUser, summary: str, answers: list[DummyAnswer]) -> None:
        self.id = report_id
        self.user_id = owner.id
        self.user = owner
        self.summary = summary
        self.response = DummyResponse(answers)


class StubReportService:
    report_map: dict[int, DummyReport] = {}

    def __init__(self, session) -> None:  # pragma: no cover - unused session stub
        self.session = session

    async def get_for_export(self, report_id: int, current_user: DummyUser) -> DummyReport:
        report = self.report_map.get(report_id)
        if report is None:
            raise HTTPException(status_code=404, detail="Report not found")
        if current_user.role != "moderator" and current_user.id != report.user_id:
            raise HTTPException(status_code=403, detail="Forbidden")
        return report

    @staticmethod
    def sort_answers(report: DummyReport) -> list[DummyAnswer]:
        answers = list(report.response.answers)
        answers.sort(
            key=lambda ans: (
                ans.question.order if ans.question and ans.question.order is not None else ans.question_id
            )
        )
        return answers


@pytest.mark.asyncio
async def test_export_report_csv_includes_summary_and_answers(monkeypatch: pytest.MonkeyPatch) -> None:
    owner = DummyUser(1, "owner@example.com", "user")
    answers = [
        DummyAnswer(1, "Answer A", DummyQuestion(1, "Question A", 1)),
        DummyAnswer(2, "Answer B", DummyQuestion(2, "Question B", 2)),
    ]
    report = DummyReport(10, owner, "Owner summary", answers)
    StubReportService.report_map = {report.id: report}
    monkeypatch.setattr(reports, "ReportService", StubReportService)

    response = await reports.export_report_csv(report.id, owner, None)

    text_body = response.body.decode()
    assert response.headers["content-type"].startswith("text/csv")
    assert "Owner summary" in text_body
    assert "Question A" in text_body
    assert "Answer B" in text_body


@pytest.mark.asyncio
async def test_export_report_pdf_accessible_for_moderator(monkeypatch: pytest.MonkeyPatch) -> None:
    owner = DummyUser(2, "owner2@example.com", "user")
    moderator = DummyUser(99, "moderator@example.com", "moderator")
    answers = [DummyAnswer(3, "A1", DummyQuestion(3, "Q1", 1))]
    report = DummyReport(11, owner, "Moderator view", answers)
    StubReportService.report_map = {report.id: report}
    monkeypatch.setattr(reports, "ReportService", StubReportService)

    response = await reports.export_report_pdf(report.id, moderator, None)

    assert response.headers["content-type"] == "application/pdf"
    assert f'report_{report.id}.pdf"' in response.headers["content-disposition"]
    assert response.body.startswith(b"%PDF")


@pytest.mark.asyncio
async def test_export_report_forbidden_for_other_user() -> None:
    owner = DummyUser(3, "owner3@example.com", "user")
    other = DummyUser(4, "other@example.com", "user")
    answers = [DummyAnswer(5, "Secret", DummyQuestion(5, "Q", 1))]
    report = DummyReport(12, owner, "Hidden summary", answers)

    class RepoStub:
        async def get_with_details(self, report_id: int) -> DummyReport | None:
            return report if report_id == report.id else None

    service = ReportService(session=None)
    service.report_repo = RepoStub()  # type: ignore[assignment]

    with pytest.raises(HTTPException) as exc_info:
        await service.get_for_export(report.id, other)

    assert exc_info.value.status_code == 403
    assert exc_info.value.detail == "Forbidden"
