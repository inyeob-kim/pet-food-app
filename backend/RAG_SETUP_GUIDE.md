# RAG 구현 가이드

## 1. 환경 변수 설정 (.env 파일)

백엔드 루트 디렉토리(`backend/`)에 `.env` 파일을 생성하고 다음을 추가하세요:

```env
# OpenAI API 설정
OPENAI_API_KEY=sk-your-openai-api-key-here
OPENAI_MODEL=gpt-4o-mini
OPENAI_TEMPERATURE=0.3
OPENAI_MAX_TOKENS=1200

# RAG Vector Store 설정 (선택사항)
# 로컬 Vector Store 사용 시
VECTOR_STORE_TYPE=local  # local, pinecone, weaviate
VECTOR_STORE_PATH=./data/vector_store

# Pinecone 사용 시 (선택사항)
PINECONE_API_KEY=your-pinecone-api-key
PINECONE_ENVIRONMENT=us-east-1
PINECONE_INDEX_NAME=pet-food-rag

# Weaviate 사용 시 (선택사항)
WEAVIATE_URL=http://localhost:8080
WEAVIATE_API_KEY=your-weaviate-api-key
```

## 2. 문서 저장 위치

### 권장 구조:
```
backend/
├── data/
│   ├── documents/          # 원본 문서 저장 위치
│   │   ├── veterinary_allergy_4th/
│   │   ├── fediaf_2025/
│   │   ├── aafco_2025/
│   │   └── small_animal_clinical_nutrition/
│   └── vector_store/        # 벡터화된 데이터 저장 위치 (자동 생성)
│       └── index.faiss     # FAISS 인덱스 (로컬 사용 시)
└── scripts/
    └── embed_documents.py  # 문서 임베딩 스크립트
```

### 문서 업로드 방법:

1. **PDF 문서인 경우**: `backend/data/documents/` 디렉토리에 폴더별로 저장
   ```
   backend/data/documents/
   ├── veterinary_allergy_4th/
   │   └── veterinary_allergy_4th_edition.pdf
   ├── fediaf_2025/
   │   └── fediaf_nutritional_guidelines_2025.pdf
   ├── aafco_2025/
   │   └── aafco_official_publication_2025.pdf
   └── small_animal_clinical_nutrition/
       └── small_animal_clinical_nutrition_5th.pdf
   ```

2. **텍스트 파일인 경우**: 각 문서를 청크 단위로 나눠서 저장
   ```
   backend/data/documents/
   ├── veterinary_allergy_4th/
   │   ├── chapter_1.txt
   │   ├── chapter_2.txt
   │   └── ...
   ```

## 3. Vector Store 선택

### 옵션 1: 로컬 FAISS (권장 - 개발/소규모)
- **장점**: 무료, 빠른 속도, 외부 의존성 없음
- **단점**: 메모리 사용량 큼, 확장성 제한적
- **설치**: `pip install faiss-cpu` (또는 `faiss-gpu`)

### 옵션 2: Chroma (로컬, 추천)
- **장점**: 사용하기 쉬움, 메타데이터 지원, 무료
- **단점**: 대규모 데이터에는 제한적
- **설치**: `pip install chromadb`

### 옵션 3: Pinecone (클라우드, 프로덕션)
- **장점**: 확장성 좋음, 관리형 서비스
- **단점**: 유료 (무료 티어 있음)
- **설치**: `pip install pinecone-client`

### 옵션 4: Weaviate (자체 호스팅/클라우드)
- **장점**: 오픈소스, 강력한 기능
- **단점**: 설정 복잡
- **설치**: `pip install weaviate-client`

## 4. 문서 임베딩 스크립트 생성

`backend/scripts/embed_documents.py` 파일을 생성하여 문서를 벡터화하는 스크립트를 작성하세요.

예시 (Chroma 사용):
```python
import os
from pathlib import Path
import chromadb
from chromadb.config import Settings
from app.utils.openai_client import get_openai_client
from app.core.config import settings

# 문서 디렉토리
DOCUMENTS_DIR = Path(__file__).parent.parent / "data" / "documents"
VECTOR_STORE_PATH = Path(__file__).parent.parent / "data" / "vector_store"

def embed_documents():
    """문서를 벡터화하여 Vector Store에 저장"""
    # Chroma 클라이언트 초기화
    client = chromadb.PersistentClient(path=str(VECTOR_STORE_PATH))
    collection = client.get_or_create_collection(
        name="pet_food_rag",
        metadata={"description": "Pet Food RAG Documents"}
    )
    
    # OpenAI 클라이언트
    openai_client = get_openai_client()
    
    # 문서 디렉토리 순회
    for doc_folder in DOCUMENTS_DIR.iterdir():
        if not doc_folder.is_dir():
            continue
        
        source_name = doc_folder.name
        print(f"Processing {source_name}...")
        
        # 각 파일 처리
        for doc_file in doc_folder.glob("*.txt"):
            with open(doc_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 청크로 분할 (예: 500자 단위)
            chunk_size = 500
            chunks = [content[i:i+chunk_size] for i in range(0, len(content), chunk_size)]
            
            # 각 청크 임베딩
            for idx, chunk in enumerate(chunks):
                # OpenAI로 임베딩 생성
                response = openai_client.embeddings.create(
                    model="text-embedding-3-small",
                    input=chunk
                )
                embedding = response.data[0].embedding
                
                # Chroma에 저장
                collection.add(
                    embeddings=[embedding],
                    documents=[chunk],
                    metadatas=[{
                        "source": source_name,
                        "file": doc_file.name,
                        "chunk_index": idx
                    }],
                    ids=[f"{source_name}_{doc_file.name}_{idx}"]
                )
    
    print("Document embedding completed!")

if __name__ == "__main__":
    embed_documents()
```

## 5. RAG 서비스 구현

`backend/app/services/rag_service.py` 파일을 생성하여 Vector Store 연동 로직을 구현하세요.

## 6. 실행 순서

1. **환경 변수 설정**
   ```bash
   cd backend
   # .env 파일 생성 및 OPENAI_API_KEY 설정
   ```

2. **의존성 설치**
   ```bash
   pip install chromadb  # 또는 선택한 Vector Store
   ```

3. **문서 준비**
   - `backend/data/documents/` 디렉토리에 문서 업로드

4. **문서 임베딩**
   ```bash
   python scripts/embed_documents.py
   ```

5. **RAG 서비스 구현**
   - `backend/app/services/rag_service.py` 구현
   - `RecommendationExplanationService`에서 RAG 서비스 호출

## 7. 참고 자료

- **Chroma**: https://docs.trychroma.com/
- **FAISS**: https://github.com/facebookresearch/faiss
- **Pinecone**: https://www.pinecone.io/docs/
- **OpenAI Embeddings**: https://platform.openai.com/docs/guides/embeddings
