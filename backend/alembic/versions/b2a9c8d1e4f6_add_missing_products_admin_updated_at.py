"""add_missing_products_admin_updated_at

Revision ID: b2a9c8d1e4f6
Revises: 9b1d7f3a6c21
Create Date: 2026-02-12 14:20:00.000000
"""
from alembic import op


# revision identifiers, used by Alembic.
revision = "b2a9c8d1e4f6"
down_revision = "9b1d7f3a6c21"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Some databases have the admin update trigger but are missing this column.
    op.execute(
        "ALTER TABLE products ADD COLUMN IF NOT EXISTS last_admin_updated_at TIMESTAMP WITH TIME ZONE"
    )


def downgrade() -> None:
    op.execute("ALTER TABLE products DROP COLUMN IF EXISTS last_admin_updated_at")
