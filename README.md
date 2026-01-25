# Pet Food App

반려동물 사료 가격 추적 및 알림 서비스

## 프로젝트 구조

```
pet-food-app/
├── backend/          # FastAPI 백엔드
│   ├── app/
│   │   ├── main.py
│   │   ├── core/     # 설정, DB, Redis, 보안
│   │   ├── db/       # DB Base, Session
│   │   ├── models/   # SQLAlchemy ORM 모델
│   │   ├── schemas/  # Pydantic 스키마
│   │   ├── api/      # API 라우터
│   │   ├── services/ # 비즈니스 로직
│   │   └── workers/ # 백그라운드 작업
│   ├── alembic/      # DB 마이그레이션
│   └── requirements.txt
│
└── frontend/         # Flutter 프론트엔드
    └── lib/
        ├── main.dart
        ├── app/       # App Shell (라우터, 테마, 설정)
        ├── core/      # 공통 (네트워크, 에러, 유틸, 위젯)
        ├── data/      # 데이터 레이어 (모델, 리포지토리)
        └── features/  # Feature-first 구조
            ├── onboarding/
            ├── pet_profile/
            ├── home/
            ├── product_detail/
            ├── alert/
            └── mypage/
```

## 기술 스택

### Backend
- **Framework**: FastAPI
- **Database**: PostgreSQL 15 (asyncpg)
- **ORM**: SQLAlchemy 2.0 (async)
- **Migration**: Alembic
- **Cache**: Redis 7
- **Authentication**: JWT (python-jose)

### Frontend
- **Framework**: Flutter
- **State Management**: Riverpod
- **Routing**: GoRouter
- **HTTP Client**: Dio
- **Code Generation**: json_serializable

## 시작하기

### Backend

1. **환경 설정**
```bash
cd backend
cp .env.example .env
# .env 파일 수정
```

2. **의존성 설치**
```bash
pip install -r requirements.txt
```

3. **Docker Compose로 서비스 실행**
```bash
# 프로젝트 루트에서 실행 (최신 Docker는 하이픈 없이 사용)
docker compose up -d postgres redis
```

4. **DB 마이그레이션**
```bash
# 초기 마이그레이션 생성
alembic revision --autogenerate -m "init"

# 마이그레이션 적용
alembic upgrade head
```

5. **서버 실행**
```bash
# 로컬 개발 (모든 네트워크 인터페이스에서 접근 가능하도록)
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

# 또는 localhost만 (시뮬레이터용)
uvicorn app.main:app --reload
```

### Frontend

1. **의존성 설치**
```bash
cd frontend
flutter pub get
```

2. **코드 생성 (DTO)**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. **앱 실행**
```bash
flutter run
```

## 개발 가이드

자세한 개발 원칙과 가이드라인은 `.cursorrules` 파일을 참고하세요.

### 주요 원칙

1. **레이어 분리**: Presentation → Domain → Data
2. **단일 책임 원칙**: 각 클래스/함수는 하나의 책임만
3. **의존성 역전**: 상위 레이어는 하위 레이어에 의존하지 않음
4. **도메인 로직 분리**: 화면/라우터에는 비즈니스 로직 없음

## API 문서

서버 실행 후 다음 URL에서 확인 가능:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## 라이선스

MIT

