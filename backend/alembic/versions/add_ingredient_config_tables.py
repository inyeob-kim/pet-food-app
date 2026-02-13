"""add_ingredient_config_tables

Revision ID: add_ingredient_config
Revises: b2a9c8d1e4f6
Create Date: 2026-01-26 12:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = 'add_ingredient_config'
down_revision = 'b2a9c8d1e4f6'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # 유해 성분 테이블 생성
    op.create_table(
        'harmful_ingredients',
        sa.Column('id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('name', sa.String(length=100), nullable=False),
        sa.Column('description', sa.String(length=500), nullable=True),
        sa.Column('severity', sa.Integer(), nullable=False, server_default='1'),
        sa.Column('is_active', sa.Boolean(), nullable=False, server_default='true'),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=False),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('name')
    )
    op.create_index('idx_harmful_ingredients_active', 'harmful_ingredients', ['is_active'])
    op.create_index('idx_harmful_ingredients_name', 'harmful_ingredients', ['name'])
    
    # 알레르기 키워드 테이블 생성
    op.create_table(
        'allergen_keywords',
        sa.Column('id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('allergen_code', sa.String(length=20), nullable=False),
        sa.Column('keyword', sa.String(length=100), nullable=False),
        sa.Column('language', sa.String(length=10), nullable=False, server_default='ko'),
        sa.Column('is_active', sa.Boolean(), nullable=False, server_default='true'),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=False),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index('idx_allergen_keywords_code', 'allergen_keywords', ['allergen_code'])
    op.create_index('idx_allergen_keywords_keyword', 'allergen_keywords', ['keyword'])
    op.create_index('idx_allergen_keywords_active', 'allergen_keywords', ['is_active'])


def downgrade() -> None:
    op.drop_index('idx_allergen_keywords_active', table_name='allergen_keywords')
    op.drop_index('idx_allergen_keywords_keyword', table_name='allergen_keywords')
    op.drop_index('idx_allergen_keywords_code', table_name='allergen_keywords')
    op.drop_table('allergen_keywords')
    
    op.drop_index('idx_harmful_ingredients_name', table_name='harmful_ingredients')
    op.drop_index('idx_harmful_ingredients_active', table_name='harmful_ingredients')
    op.drop_table('harmful_ingredients')
