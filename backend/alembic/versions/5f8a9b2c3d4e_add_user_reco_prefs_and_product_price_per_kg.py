"""add_user_reco_prefs_and_product_price_per_kg

Revision ID: 5f8a9b2c3d4e
Revises: c4dd004ede4f
Create Date: 2026-02-10 12:00:00.000000

사용자 추천 선호도 설정 및 상품 가격 정보 추가
- user_reco_prefs 테이블 생성
- products 테이블에 price_per_kg 필드 추가
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '5f8a9b2c3d4e'
down_revision = 'c4dd004ede4f'  # 최신 head로 변경
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ==============================================
    # 1) user_reco_prefs 테이블 생성
    # ==============================================
    op.create_table('user_reco_prefs',
        sa.Column('id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('user_id', postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column('prefs', postgresql.JSONB(astext_type=sa.Text()), nullable=False, server_default='{}'),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('now()')),
        sa.PrimaryKeyConstraint('id'),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE')
    )
    
    # Unique constraint: user_id는 하나의 선호도 설정만 가질 수 있음
    op.create_unique_constraint('uq_user_reco_prefs_user', 'user_reco_prefs', ['user_id'])
    
    # Index
    op.create_index('idx_user_reco_prefs_user', 'user_reco_prefs', ['user_id'], unique=False)
    
    # ==============================================
    # 2) products 테이블에 price_per_kg 필드 추가
    # ==============================================
    op.add_column('products', sa.Column('price_per_kg', sa.Numeric(10, 2), nullable=True))
    
    # Index for price filtering
    op.create_index('idx_products_price_per_kg', 'products', ['price_per_kg'], unique=False)


def downgrade() -> None:
    # Drop products price_per_kg
    op.drop_index('idx_products_price_per_kg', table_name='products')
    op.drop_column('products', 'price_per_kg')
    
    # Drop user_reco_prefs table
    op.drop_index('idx_user_reco_prefs_user', table_name='user_reco_prefs')
    op.drop_constraint('uq_user_reco_prefs_user', 'user_reco_prefs', type_='unique')
    op.drop_table('user_reco_prefs')
