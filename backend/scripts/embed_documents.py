"""
문서 임베딩 스크립트
PDF 문서를 벡터화하여 Vector Store에 저장합니다.
중복 임베딩 방지: 이미 임베딩된 문서는 스킵합니다.
"""
import os
import sys
import hashlib
from pathlib import Path
from typing import List, Dict, Set
import logging

# 프로젝트 루트를 Python 경로에 추가
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

from app.core.config import settings
from app.utils.openai_client import get_openai_client

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# 문서 디렉토리
DOCUMENTS_DIR = project_root / "data" / "documents"
VECTOR_STORE_PATH = project_root / "data" / "vector_store"

# Chroma 사용 (로컬 Vector Store)
try:
    import chromadb
    from chromadb.config import Settings
    CHROMA_AVAILABLE = True
except ImportError:
    CHROMA_AVAILABLE = False
    logger.warning("chromadb가 설치되지 않았습니다. 'pip install chromadb' 실행 필요")


def extract_text_from_pdf(pdf_path: Path) -> str:
    """PDF에서 텍스트 추출"""
    try:
        import PyPDF2
        with open(pdf_path, 'rb') as file:
            pdf_reader = PyPDF2.PdfReader(file)
            text = ""
            for page in pdf_reader.pages:
                text += page.extract_text() + "\n"
            return text
    except ImportError:
        logger.error("PyPDF2가 설치되지 않았습니다. 'pip install PyPDF2' 실행 필요")
        raise
    except Exception as e:
        logger.error(f"PDF 텍스트 추출 실패: {pdf_path}, error: {str(e)}")
        raise


def chunk_text(text: str, chunk_size: int = 500, overlap: int = 50) -> List[str]:
    """텍스트를 청크로 분할"""
    chunks = []
    start = 0
    while start < len(text):
        end = start + chunk_size
        chunk = text[start:end]
        chunks.append(chunk.strip())
        start = end - overlap  # 오버랩으로 문맥 유지
    return chunks


def get_file_hash(file_path: Path) -> str:
    """파일의 해시값 계산 (수정 시간 + 크기 기반)"""
    stat = file_path.stat()
    # 파일 크기 + 수정 시간을 기반으로 해시 생성
    content = f"{stat.st_size}_{stat.st_mtime}"
    return hashlib.md5(content.encode()).hexdigest()


def get_existing_ids(collection, source_name: str, file_stem: str) -> Set[str]:
    """기존에 임베딩된 문서 ID 목록 가져오기"""
    try:
        # 해당 소스의 모든 문서 조회
        results = collection.get(
            where={"source": source_name},
            include=["metadatas"]
        )
        
        # 같은 파일의 ID만 필터링
        existing_ids = set()
        if results["ids"] and results["metadatas"]:
            for idx, metadata in enumerate(results["metadatas"]):
                if metadata and metadata.get("file", "").startswith(file_stem):
                    existing_ids.add(results["ids"][idx])
        
        return existing_ids
    except Exception as e:
        logger.warning(f"기존 ID 조회 실패: {str(e)}")
        return set()


def embed_documents():
    """문서를 벡터화하여 Vector Store에 저장"""
    if not CHROMA_AVAILABLE:
        logger.error("chromadb를 설치해주세요: pip install chromadb")
        return
    
    if not settings.OPENAI_API_KEY:
        logger.error("OPENAI_API_KEY가 설정되지 않았습니다. .env 파일을 확인하세요.")
        return
    
    # Chroma 클라이언트 초기화
    VECTOR_STORE_PATH.mkdir(parents=True, exist_ok=True)
    client = chromadb.PersistentClient(path=str(VECTOR_STORE_PATH))
    
    # 컬렉션 생성 또는 가져오기
    collection = client.get_or_create_collection(
        name="pet_food_rag",
        metadata={"description": "Pet Food RAG Documents"}
    )
    
    existing_count = collection.count()
    logger.info(f"📊 기존 문서 수: {existing_count}개")
    
    # OpenAI 클라이언트
    openai_client = get_openai_client()
    
    # 문서 디렉토리 순회
    total_chunks = 0
    skipped_chunks = 0
    new_chunks = 0
    
    for doc_folder in DOCUMENTS_DIR.iterdir():
        if not doc_folder.is_dir():
            continue
        
        source_name = doc_folder.name
        logger.info(f"📁 Processing {source_name}...")
        
        # PDF 파일 찾기
        pdf_files = list(doc_folder.glob("*.pdf"))
        if not pdf_files:
            logger.info(f"  ⚠️  PDF 파일이 없습니다: {source_name}")
            continue
        
        for pdf_file in pdf_files:
            logger.info(f"  📄 Processing {pdf_file.name}...")
            
            try:
                # 파일 해시 계산 (변경 감지용)
                file_hash = get_file_hash(pdf_file)
                file_stem = pdf_file.stem
                
                # 기존에 임베딩된 ID 목록 가져오기
                existing_ids = get_existing_ids(collection, source_name, file_stem)
                
                if existing_ids:
                    logger.info(f"  ℹ️  기존 임베딩 발견: {len(existing_ids)}개 청크")
                    # TODO: 파일 해시 비교로 변경 감지 (현재는 ID 존재 여부만 체크)
                
                # PDF에서 텍스트 추출
                text = extract_text_from_pdf(pdf_file)
                if not text.strip():
                    logger.warning(f"  ⚠️  텍스트가 추출되지 않았습니다: {pdf_file.name}")
                    continue
                
                logger.info(f"  ✅ 텍스트 추출 완료: {len(text)}자")
                
                # 청크로 분할
                chunks = chunk_text(text, chunk_size=500, overlap=50)
                logger.info(f"  📦 {len(chunks)}개 청크로 분할")
                
                # 각 청크 임베딩 (신규만)
                embeddings = []
                documents = []
                metadatas = []
                ids = []
                
                for idx, chunk in enumerate(chunks):
                    chunk_id = f"{source_name}_{file_stem}_{idx}"
                    
                    # 이미 임베딩된 청크는 스킵
                    if chunk_id in existing_ids:
                        skipped_chunks += 1
                        if (idx + 1) % 50 == 0:
                            logger.info(f"    스킵 중: {idx + 1}/{len(chunks)} (이미 임베딩됨)")
                        continue
                    
                    try:
                        # OpenAI로 임베딩 생성
                        response = openai_client.embeddings.create(
                            model="text-embedding-3-small",  # 저렴하고 빠른 모델
                            input=chunk
                        )
                        embedding = response.data[0].embedding
                        
                        embeddings.append(embedding)
                        documents.append(chunk)
                        metadatas.append({
                            "source": source_name,
                            "file": pdf_file.name,
                            "file_hash": file_hash,  # 파일 해시 저장 (변경 감지용)
                            "chunk_index": idx,
                            "total_chunks": len(chunks)
                        })
                        ids.append(chunk_id)
                        new_chunks += 1
                        
                        if (idx + 1) % 10 == 0:
                            logger.info(f"    진행 중: {idx + 1}/{len(chunks)} (신규: {new_chunks}, 스킵: {skipped_chunks})")
                    
                    except Exception as e:
                        logger.error(f"    ❌ 청크 {idx} 임베딩 실패: {str(e)}")
                        continue
                
                # Chroma에 일괄 저장 (신규 청크만)
                if embeddings:
                    try:
                        collection.add(
                            embeddings=embeddings,
                            documents=documents,
                            metadatas=metadatas,
                            ids=ids
                        )
                        total_chunks += len(embeddings)
                        logger.info(f"  ✅ {len(embeddings)}개 신규 청크 저장 완료")
                    except Exception as e:
                        # 중복 ID 에러 처리
                        if "duplicate" in str(e).lower() or "already exists" in str(e).lower():
                            logger.warning(f"  ⚠️  일부 청크가 이미 존재합니다: {str(e)}")
                        else:
                            logger.error(f"  ❌ 저장 실패: {str(e)}")
                else:
                    logger.info(f"  ℹ️  모든 청크가 이미 임베딩되어 있습니다. 스킵합니다.")
            
            except Exception as e:
                logger.error(f"  ❌ 파일 처리 실패: {pdf_file.name}, error: {str(e)}")
                continue
    
    final_count = collection.count()
    logger.info("=" * 60)
    logger.info(f"✅ 문서 임베딩 완료!")
    logger.info(f"📊 신규 저장: {total_chunks}개 청크")
    logger.info(f"⏭️  스킵됨: {skipped_chunks}개 청크 (이미 임베딩됨)")
    logger.info(f"📈 최종 문서 수: {final_count}개 (기존: {existing_count}개)")
    logger.info("=" * 60)


if __name__ == "__main__":
    embed_documents()
