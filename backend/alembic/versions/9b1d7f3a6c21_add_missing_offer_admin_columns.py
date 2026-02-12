"""add_missing_offer_admin_columns

Revision ID: 9b1d7f3a6c21
Revises: 5f8a9b2c3d4e
Create Date: 2026-02-12 13:55:00.000000
"""
from alembic import op


# revision identifiers, used by Alembic.
revision = "9b1d7f3a6c21"
down_revision = "5f8a9b2c3d4e"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Offer admin fields were introduced in a different migration path.
    # Keep this migration idempotent for environments that may already have some fields.
    op.execute(
        """
        DO $$
        BEGIN
          IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'offer_fetch_status') THEN
            CREATE TYPE offer_fetch_status AS ENUM ('SUCCESS', 'FAILED', 'PENDING', 'NOT_FETCHED');
          END IF;
        END$$;
        """
    )

    op.execute("ALTER TABLE product_offers ADD COLUMN IF NOT EXISTS platform_image_url VARCHAR(500)")
    op.execute("ALTER TABLE product_offers ADD COLUMN IF NOT EXISTS display_priority SMALLINT NOT NULL DEFAULT 10")
    op.execute("ALTER TABLE product_offers ADD COLUMN IF NOT EXISTS admin_note TEXT")
    op.execute(
        "ALTER TABLE product_offers ADD COLUMN IF NOT EXISTS last_fetch_status offer_fetch_status NOT NULL DEFAULT 'NOT_FETCHED'"
    )
    op.execute("ALTER TABLE product_offers ADD COLUMN IF NOT EXISTS last_fetch_error TEXT")
    op.execute("ALTER TABLE product_offers ADD COLUMN IF NOT EXISTS last_fetched_at TIMESTAMP WITH TIME ZONE")
    op.execute("ALTER TABLE product_offers ADD COLUMN IF NOT EXISTS current_price INTEGER")
    op.execute("ALTER TABLE product_offers ADD COLUMN IF NOT EXISTS currency CHAR(3) NOT NULL DEFAULT 'KRW'")
    op.execute("ALTER TABLE product_offers ADD COLUMN IF NOT EXISTS last_seen_price INTEGER")


def downgrade() -> None:
    op.execute("ALTER TABLE product_offers DROP COLUMN IF EXISTS last_seen_price")
    op.execute("ALTER TABLE product_offers DROP COLUMN IF EXISTS currency")
    op.execute("ALTER TABLE product_offers DROP COLUMN IF EXISTS current_price")
    op.execute("ALTER TABLE product_offers DROP COLUMN IF EXISTS last_fetched_at")
    op.execute("ALTER TABLE product_offers DROP COLUMN IF EXISTS last_fetch_error")
    op.execute("ALTER TABLE product_offers DROP COLUMN IF EXISTS last_fetch_status")
    op.execute("ALTER TABLE product_offers DROP COLUMN IF EXISTS admin_note")
    op.execute("ALTER TABLE product_offers DROP COLUMN IF EXISTS display_priority")
    op.execute("ALTER TABLE product_offers DROP COLUMN IF EXISTS platform_image_url")

    op.execute(
        """
        DO $$
        BEGIN
          IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'offer_fetch_status') THEN
            DROP TYPE offer_fetch_status;
          END IF;
        END$$;
        """
    )
