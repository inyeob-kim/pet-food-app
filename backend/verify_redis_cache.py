"""Redis 캐시 구현 검증 스크립트 (네트워크 없이 코드 검증만)"""
import ast
import sys
from pathlib import Path


def check_imports(file_path: Path, backend_path: Path) -> list:
    """파일의 import 문 검증"""
    errors = []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            tree = ast.parse(f.read(), filename=str(file_path))
        
        imports = []
        for node in ast.walk(tree):
            if isinstance(node, ast.Import):
                for alias in node.names:
                    imports.append(alias.name)
            elif isinstance(node, ast.ImportFrom):
                module = node.module or ''
                for alias in node.names:
                    imports.append(f"{module}.{alias.name}")
        
        # 필수 import 확인
        required_imports = {
            'app/core/cache/recommendation_cache_service.py': ['redis.asyncio', 'json', 'datetime', 'app.core.redis', 'app.core.cache.cache_keys', 'app.schemas.product'],
            'app/services/product_service.py': ['app.core.cache.recommendation_cache_service'],
            'app/api/v1/pets.py': ['app.core.cache.recommendation_cache_service'],
            'app/api/v1/products.py': ['app.core.cache.recommendation_cache_service'],
        }
        
        # 상대 경로로 변환
        try:
            file_key = str(file_path.relative_to(backend_path))
        except ValueError:
            # 절대 경로인 경우, backend_path를 기준으로 변환 시도
            if str(file_path).startswith(str(backend_path)):
                file_key = str(file_path)[len(str(backend_path)) + 1:]
            else:
                # 파일명만 사용
                file_key = file_path.name
        
        if file_key in required_imports:
            for req in required_imports[file_key]:
                if not any(req in imp for imp in imports):
                    errors.append(f"❌ {file_path.name}: 필수 import 누락 - {req}")
        
        return errors
    except Exception as e:
        return [f"❌ {file_path.name}: 파싱 오류 - {e}"]


def check_redis_integration():
    """Redis 통합 코드 검증"""
    print("=" * 60)
    print("Redis 캐시 구현 검증")
    print("=" * 60)
    
    # 현재 스크립트 위치 기준으로 backend 경로 찾기
    script_dir = Path(__file__).parent
    if (script_dir / 'app').exists():
        backend_path = script_dir
    else:
        backend_path = Path('backend')
    errors = []
    warnings = []
    
    # 1. 필수 파일 존재 확인
    required_files = [
        'app/core/cache/__init__.py',
        'app/core/cache/cache_keys.py',
        'app/core/cache/recommendation_cache_service.py',
    ]
    
    print("\n=== 1. 필수 파일 확인 ===")
    for file_path in required_files:
        full_path = backend_path / file_path
        if full_path.exists():
            print(f"✅ {file_path}")
        else:
            print(f"❌ {file_path} - 파일이 없습니다")
            errors.append(f"파일 없음: {file_path}")
    
    # 2. Import 검증
    print("\n=== 2. Import 검증 ===")
    files_to_check = [
        backend_path / 'app/core/cache/recommendation_cache_service.py',
        backend_path / 'app/services/product_service.py',
        backend_path / 'app/api/v1/pets.py',
        backend_path / 'app/api/v1/products.py',
    ]
    
    for file_path in files_to_check:
        if file_path.exists():
            file_errors = check_imports(file_path, backend_path)
            if file_errors:
                errors.extend(file_errors)
            else:
                print(f"✅ {file_path.name}: Import 정상")
    
    # 3. 코드 패턴 검증
    print("\n=== 3. 코드 패턴 검증 ===")
    
    # ProductService에서 Redis 통합 확인
    product_service = backend_path / 'app/services/product_service.py'
    if product_service.exists():
        content = product_service.read_text(encoding='utf-8')
        if 'RecommendationCacheService.get_recommendation' in content:
            print("✅ ProductService: Redis 캐시 조회 통합됨")
        else:
            errors.append("ProductService에 Redis 캐시 조회가 없습니다")
        
        if 'RecommendationCacheService.set_recommendation' in content:
            print("✅ ProductService: Redis 캐시 저장 통합됨")
        else:
            errors.append("ProductService에 Redis 캐시 저장이 없습니다")
    
    # 펫 업데이트에서 무효화 확인
    pets_api = backend_path / 'app/api/v1/pets.py'
    if pets_api.exists():
        content = pets_api.read_text(encoding='utf-8')
        if 'invalidate_recommendation' in content:
            print("✅ Pets API: 캐시 무효화 통합됨")
        else:
            errors.append("Pets API에 캐시 무효화가 없습니다")
    
    # 수동 캐시 삭제 API 확인
    products_api = backend_path / 'app/api/v1/products.py'
    if products_api.exists():
        content = products_api.read_text(encoding='utf-8')
        if 'invalidate_recommendation' in content:
            print("✅ Products API: 수동 캐시 삭제 통합됨")
        else:
            warnings.append("Products API에 수동 캐시 삭제가 없을 수 있습니다")
    
    # 4. 에러 처리 확인
    print("\n=== 4. 에러 처리 확인 ===")
    cache_service = backend_path / 'app/core/cache/recommendation_cache_service.py'
    if cache_service.exists():
        content = cache_service.read_text(encoding='utf-8')
        if 'redis.RedisError' in content:
            print("✅ RecommendationCacheService: Redis 에러 처리 있음")
        else:
            warnings.append("Redis 에러 처리가 없을 수 있습니다")
        
        if 'fallback' in content.lower():
            print("✅ RecommendationCacheService: Fallback 로직 있음")
        else:
            warnings.append("Fallback 로직이 없을 수 있습니다")
    
    # 결과 출력
    print("\n" + "=" * 60)
    if errors:
        print("❌ 검증 실패:")
        for error in errors:
            print(f"  - {error}")
        return False
    elif warnings:
        print("⚠️ 경고:")
        for warning in warnings:
            print(f"  - {warning}")
        print("\n✅ 코드 검증 완료 (경고 있음)")
        return True
    else:
        print("✅ 모든 검증 통과!")
        return True


if __name__ == "__main__":
    success = check_redis_integration()
    sys.exit(0 if success else 1)
