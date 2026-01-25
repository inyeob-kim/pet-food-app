from datetime import datetime, timezone, timedelta


def get_utc_now() -> datetime:
    """UTC 현재 시간 반환"""
    return datetime.now(timezone.utc)


def to_kst(dt: datetime) -> datetime:
    """UTC를 KST로 변환"""
    kst = timezone(timedelta(hours=9))
    return dt.astimezone(kst)

