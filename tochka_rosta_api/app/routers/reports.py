import csv
from datetime import datetime
from io import BytesIO, StringIO

from fastapi import APIRouter, Depends, Path
from fastapi.responses import Response

try:  # pragma: no cover - optional dependency
    from reportlab.lib.pagesizes import A4  # type: ignore
    from reportlab.pdfgen import canvas  # type: ignore
except ModuleNotFoundError:  # pragma: no cover - executed only when optional dependency missing
    A4 = None
    canvas = None
from sqlalchemy.ext.asyncio import AsyncSession

from ..core.database import get_session
from ..core.security import get_current_user, require_role
from ..models.user import User
from ..schemas.report import ReportRead, ReportUpdate
from ..services.report import ReportService

router = APIRouter(prefix="/reports", tags=["reports"])


@router.get("", response_model=list[ReportRead])
async def my_reports(
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> list[ReportRead]:
    service = ReportService(session)
    return await service.list_my_reports(current_user.id)


@router.get("/{report_id}", response_model=ReportRead)
@require_role("moderator")
async def get_report(
    report_id: int = Path(..., ge=1),
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> ReportRead:
    service = ReportService(session)
    return await service.get(report_id)


@router.patch("/{report_id}", response_model=ReportRead)
@require_role("moderator")
async def update_report(
    payload: ReportUpdate,
    report_id: int = Path(..., ge=1),
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> ReportRead:
    service = ReportService(session)
    return await service.update(report_id, payload)


def _format_question(answer) -> str:
    if answer.question and answer.question.text:
        return answer.question.text
    return f"Question {answer.question_id}"


@router.get("/{report_id}/export.csv")
async def export_report_csv(
    report_id: int = Path(..., ge=1),
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> Response:
    service = ReportService(session)
    report = await service.get_for_export(report_id, current_user)
    answers = service.sort_answers(report)

    buffer = StringIO()
    writer = csv.writer(buffer)
    writer.writerow(["Report", report.id])
    writer.writerow(["Owner", report.user.email if report.user else report.user_id])
    writer.writerow(["Summary", report.summary or ""])
    writer.writerow(["Generated at", datetime.utcnow().isoformat()])
    writer.writerow([])
    writer.writerow(["Question", "Answer"])
    for answer in answers:
        writer.writerow([_format_question(answer), answer.answer])

    headers = {"Content-Disposition": f'attachment; filename="report_{report_id}.csv"'}
    return Response(content=buffer.getvalue(), media_type="text/csv", headers=headers)


@router.get("/{report_id}/export.pdf")
async def export_report_pdf(
    report_id: int = Path(..., ge=1),
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> Response:
    service = ReportService(session)
    report = await service.get_for_export(report_id, current_user)
    answers = service.sort_answers(report)

    pdf_bytes = _build_pdf_document(report.summary or "", answers)
    headers = {"Content-Disposition": f'attachment; filename="report_{report_id}.pdf"'}
    return Response(content=pdf_bytes, media_type="application/pdf", headers=headers)


def _wrap_text(text: str, max_chars: int = 80) -> list[str]:
    lines: list[str] = []
    for paragraph in text.splitlines() or [""]:
        words = paragraph.split()
        if not words:
            lines.append("")
            continue
        current = words[0]
        for word in words[1:]:
            if len(current) + 1 + len(word) > max_chars:
                lines.append(current)
                current = word
            else:
                current = f"{current} {word}"
        lines.append(current)
    if not lines:
        lines.append("")
    return lines


def _escape_pdf_text(value: str) -> str:
    return value.replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)")


def _build_pdf_document(summary: str, answers) -> bytes:
    if canvas is not None and A4 is not None:
        return _build_pdf_with_reportlab(summary, answers)
    return _build_pdf_fallback(summary, answers)


def _build_pdf_with_reportlab(summary: str, answers) -> bytes:
    buffer = BytesIO()
    pdf = canvas.Canvas(buffer, pagesize=A4)
    width, height = A4
    margin = 72
    y_position = height - margin

    def ensure_space(required_height: int, font_name: str, font_size: int) -> None:
        nonlocal y_position
        if y_position - required_height < margin:
            pdf.showPage()
            pdf.setFont(font_name, font_size)
            y_position = height - margin

    pdf.setFont("Helvetica-Bold", 20)
    pdf.drawString(margin, y_position, "Tochka Rosta")
    y_position -= 26

    pdf.setFont("Helvetica", 10)
    pdf.drawString(margin, y_position, datetime.utcnow().strftime("%Y-%m-%d %H:%M UTC"))
    y_position -= 28

    pdf.setFont("Helvetica-Bold", 14)
    pdf.drawString(margin, y_position, "Summary")
    y_position -= 22

    pdf.setFont("Helvetica", 12)
    for line in _wrap_text(summary, 90):
        ensure_space(16, "Helvetica", 12)
        pdf.drawString(margin, y_position, line)
        y_position -= 16

    y_position -= 14
    ensure_space(22, "Helvetica-Bold", 14)
    pdf.setFont("Helvetica-Bold", 14)
    pdf.drawString(margin, y_position, "Key Answers")
    y_position -= 22

    pdf.setFont("Helvetica", 12)
    if not answers:
        ensure_space(16, "Helvetica", 12)
        pdf.drawString(margin, y_position, "No answers provided")
        y_position -= 16
    else:
        for answer in answers:
            text = f"{_format_question(answer)}: {answer.answer}"
            wrapped_lines = _wrap_text(text, 90)
            for line in wrapped_lines:
                ensure_space(16, "Helvetica", 12)
                pdf.drawString(margin, y_position, line)
                y_position -= 16
            y_position -= 8

    pdf.save()
    return buffer.getvalue()


def _build_pdf_fallback(summary: str, answers) -> bytes:
    width, height = 595, 842  # A4 in points
    y_position = height - 72
    content_lines: list[str] = []

    def add_line(text: str, font_size: int, spacing: int) -> None:
        nonlocal y_position
        content_lines.extend(
            [
                "BT",
                f"/F1 {font_size} Tf",
                f"1 0 0 1 72 {y_position} Tm",
                f"({_escape_pdf_text(text)}) Tj",
                "ET",
            ]
        )
        y_position -= spacing

    add_line("Tochka Rosta", 20, 26)
    add_line(datetime.utcnow().strftime("%Y-%m-%d %H:%M UTC"), 10, 18)
    y_position -= 10
    add_line("Summary", 14, 22)
    for line in _wrap_text(summary, 90):
        add_line(line, 12, 16)
    y_position -= 14
    add_line("Key Answers", 14, 22)
    if not answers:
        add_line("No answers provided", 12, 16)
    else:
        for answer in answers:
            text = f"{_format_question(answer)}: {answer.answer}"
            for wrapped in _wrap_text(text, 90):
                add_line(wrapped, 12, 16)
            y_position -= 8

    content_stream = "\n".join(content_lines) + "\n"
    content_bytes = content_stream.encode("utf-8")

    buffer = bytearray()
    buffer.extend(b"%PDF-1.4\n")

    objects: list[bytes] = [
        b"<< /Type /Catalog /Pages 2 0 R >>",
        b"<< /Type /Pages /Kids [3 0 R] /Count 1 >>",
        b"<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 5 0 R >> >> /Contents 4 0 R >>",
        f"<< /Length {len(content_bytes)} >>\nstream\n{content_stream}endstream".encode("utf-8"),
        b"<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>",
    ]

    offsets = [0]
    for index, obj in enumerate(objects, start=1):
        offsets.append(len(buffer))
        buffer.extend(f"{index} 0 obj\n".encode("utf-8"))
        buffer.extend(obj)
        buffer.extend(b"\nendobj\n")

    xref_position = len(buffer)
    buffer.extend(f"xref\n0 {len(objects) + 1}\n".encode("utf-8"))
    buffer.extend(b"0000000000 65535 f \n")
    for offset in offsets[1:]:
        buffer.extend(f"{offset:010d} 00000 n \n".encode("utf-8"))

    buffer.extend(
        f"trailer\n<< /Size {len(objects) + 1} /Root 1 0 R >>\nstartxref\n{xref_position}\n%%EOF".encode("utf-8")
    )
    return bytes(buffer)
