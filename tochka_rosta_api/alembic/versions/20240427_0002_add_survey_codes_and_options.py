"""Add survey codes and options

Revision ID: 20240427_0002
Revises: 20240208_0001
Create Date: 2024-04-27 00:00:00.000000
"""

from alembic import op
import sqlalchemy as sa


revision = "20240427_0002"
down_revision = "20240208_0001"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column("survey_sections", sa.Column("code", sa.String(length=100), nullable=True))
    op.add_column("survey_questions", sa.Column("code", sa.String(length=100), nullable=True))
    op.add_column(
        "survey_questions",
        sa.Column("required", sa.Boolean(), server_default=sa.false(), nullable=False),
    )
    op.add_column("survey_questions", sa.Column("meta", sa.JSON(), nullable=True))

    op.create_unique_constraint("uq_survey_sections_code", "survey_sections", ["code"])
    op.create_unique_constraint("uq_survey_questions_code", "survey_questions", ["code"])

    op.create_table(
        "survey_options",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column(
            "question_id",
            sa.Integer(),
            sa.ForeignKey("survey_questions.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("value", sa.String(length=255), nullable=False),
        sa.Column("label", sa.String(length=255), nullable=False),
        sa.Column("order", sa.Integer(), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
    )


def downgrade() -> None:
    op.drop_table("survey_options")
    op.drop_constraint("uq_survey_questions_code", "survey_questions", type_="unique")
    op.drop_constraint("uq_survey_sections_code", "survey_sections", type_="unique")

    op.drop_column("survey_questions", "meta")
    op.drop_column("survey_questions", "required")
    op.drop_column("survey_questions", "code")
    op.drop_column("survey_sections", "code")
