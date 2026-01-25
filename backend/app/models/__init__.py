# 모든 모델을 import하여 Alembic이 인식할 수 있도록 함
from app.models.user import User
from app.models.pet import Pet
from app.models.product import Product
from app.models.offer import ProductOffer
from app.models.price import PriceSnapshot, PriceSummary
from app.models.tracking import Tracking
from app.models.alert import Alert, AlertEvent
from app.models.outbound_click import OutboundClick

__all__ = [
    "User",
    "Pet",
    "Product",
    "ProductOffer",
    "PriceSnapshot",
    "PriceSummary",
    "Tracking",
    "Alert",
    "AlertEvent",
    "OutboundClick",
]
