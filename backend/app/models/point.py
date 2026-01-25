# 포인트 관련 모델 (optional - MVP에서는 사용하지 않음)
# from sqlalchemy import Column, Integer, String, ForeignKey
# from sqlalchemy.dialects.postgresql import UUID
# import uuid
# import enum
# 
# from app.db.base import Base, TimestampMixin
# 
# 
# class PointReason(str, enum.Enum):
#     AFFILIATE_CLICK = "AFFILIATE_CLICK"
#     SIGNUP_BONUS = "SIGNUP_BONUS"
#     PURCHASE = "PURCHASE"
# 
# 
# class PointLedger(Base, TimestampMixin):
#     __tablename__ = "point_ledger"
# 
#     id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
#     user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False, index=True)
#     amount = Column(Integer, nullable=False)  # 양수: 적립, 음수: 사용
#     reason = Column(SQLEnum(PointReason), nullable=False)
#     description = Column(String(255), nullable=True)
# 
# 
# class UserBalance(Base, TimestampMixin):
#     __tablename__ = "user_balances"
# 
#     id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
#     user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False, unique=True)
#     balance = Column(Integer, default=0, nullable=False)
