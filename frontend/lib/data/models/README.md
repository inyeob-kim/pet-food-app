# DTO Models

이 디렉토리는 FastAPI OpenAPI 스키마와 1:1로 매칭되는 DTO 모델을 포함합니다.

## 코드 생성

DTO 파일들은 `json_serializable`을 사용하여 `fromJson`/`toJson` 메서드를 자동 생성합니다.

### 실행 명령어

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 파일 구조

- `pet_dto.dart` - 반려동물 관련 DTO
- `product_dto.dart` - 상품 관련 DTO
- `price_summary_dto.dart` - 가격 요약 DTO
- `recommendation_dto.dart` - 추천 상품 관련 DTO
- `tracking_dto.dart` - 가격 추적 관련 DTO
- `alert_dto.dart` - 알림 관련 DTO
- `click_dto.dart` - 클릭 이벤트 관련 DTO

각 DTO는 백엔드의 Pydantic schema와 필드명과 타입이 일치합니다.

