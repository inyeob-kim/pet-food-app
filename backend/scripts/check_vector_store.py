"""
Vector Store 확인 스크립트
임베딩된 문서가 있는지 확인합니다.
"""
import sys
from pathlib import Path

# 프로젝트 루트를 Python 경로에 추가
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

try:
    import chromadb
    
    # Vector Store 경로
    vector_store_path = project_root / "data" / "vector_store"
    
    if not vector_store_path.exists():
        print("❌ Vector Store 디렉토리가 없습니다.")
        print(f"   경로: {vector_store_path}")
        exit(1)
    
    # Chroma 클라이언트 초기화
    client = chromadb.PersistentClient(path=str(vector_store_path))
    
    # 컬렉션 목록 확인
    collections = client.list_collections()
    print(f"📚 컬렉션 수: {len(collections)}")
    print()
    
    if not collections:
        print("❌ 컬렉션이 없습니다.")
        print("   문서 임베딩을 먼저 실행하세요: python scripts/embed_documents.py")
        exit(1)
    
    # pet_food_rag 컬렉션 확인
    try:
        collection = client.get_collection(name="pet_food_rag")
        
        count = collection.count()
        print(f"✅ 컬렉션 'pet_food_rag' 발견!")
        print(f"📊 총 문서 청크 수: {count:,}개")
        print()
        
        if count == 0:
            print("⚠️  컬렉션은 있지만 문서가 없습니다.")
            exit(1)
        
        # 샘플 데이터 확인
        print("📄 샘플 데이터 (최대 3개):")
        print("-" * 60)
        
        results = collection.get(limit=3, include=["documents", "metadatas"])
        
        if results["ids"]:
            for idx, doc_id in enumerate(results["ids"], 1):
                metadata = results["metadatas"][idx - 1] if results["metadatas"] else {}
                document = results["documents"][idx - 1] if results["documents"] else ""
                
                print(f"\n{idx}. ID: {doc_id}")
                print(f"   소스: {metadata.get('source', 'Unknown')}")
                print(f"   파일: {metadata.get('file', 'Unknown')}")
                print(f"   청크 인덱스: {metadata.get('chunk_index', 'Unknown')}")
                print(f"   내용 미리보기: {document[:100]}...")
        else:
            print("   샘플 데이터를 가져올 수 없습니다.")
        
        print()
        print("-" * 60)
        
        # 소스별 통계
        print("\n📈 소스별 통계:")
        all_results = collection.get(include=["metadatas"])
        
        if all_results["metadatas"]:
            source_counts = {}
            for metadata in all_results["metadatas"]:
                if metadata:
                    source = metadata.get("source", "Unknown")
                    source_counts[source] = source_counts.get(source, 0) + 1
            
            for source, count in sorted(source_counts.items()):
                print(f"   - {source}: {count:,}개 청크")
        
        print()
        print("✅ Vector Store가 정상적으로 설정되었습니다!")
        print("   RAG 기능을 사용할 수 있습니다.")
        
    except Exception as e:
        print(f"❌ 컬렉션 'pet_food_rag'를 찾을 수 없습니다: {str(e)}")
        print("   문서 임베딩을 먼저 실행하세요: python scripts/embed_documents.py")
        exit(1)
        
except ImportError:
    print("❌ chromadb가 설치되지 않았습니다.")
    print("   설치: pip install chromadb")
    exit(1)
except Exception as e:
    print(f"❌ 오류 발생: {str(e)}")
    import traceback
    traceback.print_exc()
    exit(1)
