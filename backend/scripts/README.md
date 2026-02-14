# 문서 임베딩 스크립트

## 사용 방법

### 1. 의존성 설치
```bash
pip install chromadb PyPDF2
```

또는 requirements.txt에 이미 추가되어 있으므로:
```bash
pip install -r requirements.txt
```

### 2. 환경 변수 설정
`backend/.env` 파일에 OpenAI API Key 설정:
```env
OPENAI_API_KEY=sk-your-key-here
```

### 3. 문서 준비
`backend/data/documents/` 폴더에 PDF 파일을 업로드:
```
backend/data/documents/
├── veterinary_allergy_4th/
│   └── veterinary_allergy_4th.pdf
├── fediaf_2025/
│   └── (나중에 추가)
└── ...
```

### 4. 문서 임베딩 실행
```bash
cd backend
python scripts/embed_documents.py
```

## 현재 상태

- ✅ Veterinary Allergy 4th Edition 문서 준비됨
- ⏳ 나머지 문서는 나중에 추가 가능

## 참고사항

- PDF 파일은 자동으로 텍스트로 추출됩니다
- 각 문서는 500자 단위로 청크로 분할됩니다 (50자 오버랩)
- OpenAI의 `text-embedding-3-small` 모델을 사용합니다 (저렴하고 빠름)
- 벡터 데이터는 `backend/data/vector_store/`에 저장됩니다
