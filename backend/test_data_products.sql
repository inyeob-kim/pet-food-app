-- 테스트 데이터 생성 스크립트
-- products, product_offers, product_nutrition_facts, product_allergens, product_ingredient_profiles 테이블용

-- 먼저 알레르겐 코드와 클레임 코드가 필요합니다 (없으면 생성)
INSERT INTO allergen_codes (code, display_name) VALUES
('CHICKEN', '닭고기'),
('BEEF', '소고기'),
('PORK', '돼지고기'),
('FISH', '생선'),
('EGG', '계란'),
('DAIRY', '유제품'),
('WHEAT', '밀'),
('CORN', '옥수수'),
('SOY', '대두'),
('RICE', '쌀')
ON CONFLICT (code) DO NOTHING;

INSERT INTO claim_codes (code, display_name) VALUES
('GRAIN_FREE', '그레인프리'),
('NATURAL', '자연식'),
('ORGANIC', '유기농'),
('HYPOSENSITIVITY', '저알레르기'),
('WEIGHT_MANAGEMENT', '체중관리'),
('SKIN_HEALTH', '피부건강'),
('DIGESTIVE_HEALTH', '소화건강'),
('JOINT_HEALTH', '관절건강'),
('DENTAL_HEALTH', '구강건강'),
('SENIOR', '노령견용')
ON CONFLICT (code) DO NOTHING;

-- 1. 로얄캐닌 미니 어덜트 (소형견용)
INSERT INTO products (id, category, brand_name, product_name, size_label, species, is_active, created_at, updated_at) VALUES
('11111111-1111-1111-1111-111111111111', 'FOOD', '로얄캐닌', '미니 어덜트', '3kg', 'DOG', true, NOW(), NOW()),
('22222222-2222-2222-2222-222222222222', 'FOOD', '로얄캐닌', '미니 어덜트', '7.5kg', 'DOG', true, NOW(), NOW()),
('33333333-3333-3333-3333-333333333333', 'FOOD', '힐스', '사이언스 다이어트 어덜트', '3kg', 'DOG', true, NOW(), NOW()),
('44444444-4444-4444-4444-444444444444', 'FOOD', '힐스', '사이언스 다이어트 어덜트', '7kg', 'DOG', true, NOW(), NOW()),
('55555555-5555-5555-5555-555555555555', 'FOOD', '퍼피', '퍼피 어덜트', '2.5kg', 'DOG', true, NOW(), NOW()),
('66666666-6666-6666-6666-666666666666', 'FOOD', '퍼피', '퍼피 어덜트', '5kg', 'DOG', true, NOW(), NOW()),
('77777777-7777-7777-7777-777777777777', 'FOOD', '네이처스 버라이어티', '인스팅트 오리지널', '4.5kg', 'DOG', true, NOW(), NOW()),
('88888888-8888-8888-8888-888888888888', 'FOOD', '네이처스 버라이어티', '인스팅트 오리지널', '11kg', 'DOG', true, NOW(), NOW()),
('99999999-9999-9999-9999-999999999999', 'FOOD', '아카나', '그래스랜드 독', '6kg', 'DOG', true, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'FOOD', '오리젠', '오리지널 독', '5.4kg', 'DOG', true, NOW(), NOW());

-- product_offers 데이터
INSERT INTO product_offers (id, product_id, merchant, merchant_product_id, url, affiliate_url, is_primary, is_active, created_at, updated_at) VALUES
-- 로얄캐닌 미니 어덜트 3kg
('11111111-1111-1111-1111-111111111101', '11111111-1111-1111-1111-111111111111', 'COUPANG', 'COUPANG_001', 'https://www.coupang.com/vp/products/123456', 'https://link.coupang.com/a/abc123', true, true, NOW(), NOW()),
('11111111-1111-1111-1111-111111111102', '11111111-1111-1111-1111-111111111111', 'NAVER', 'NAVER_001', 'https://shopping.naver.com/catalog/123456', NULL, false, true, NOW(), NOW()),
-- 로얄캐닌 미니 어덜트 7.5kg
('22222222-2222-2222-2222-222222222201', '22222222-2222-2222-2222-222222222222', 'COUPANG', 'COUPANG_002', 'https://www.coupang.com/vp/products/123457', 'https://link.coupang.com/a/abc124', true, true, NOW(), NOW()),
-- 힐스 사이언스 다이어트 어덜트 3kg
('33333333-3333-3333-3333-333333333301', '33333333-3333-3333-3333-333333333333', 'COUPANG', 'COUPANG_003', 'https://www.coupang.com/vp/products/123458', 'https://link.coupang.com/a/abc125', true, true, NOW(), NOW()),
('33333333-3333-3333-3333-333333333302', '33333333-3333-3333-3333-333333333333', 'BRAND', 'HILLS_001', 'https://www.hills.co.kr/products/123458', NULL, false, true, NOW(), NOW()),
-- 힐스 사이언스 다이어트 어덜트 7kg
('44444444-4444-4444-4444-444444444401', '44444444-4444-4444-4444-444444444444', 'COUPANG', 'COUPANG_004', 'https://www.coupang.com/vp/products/123459', 'https://link.coupang.com/a/abc126', true, true, NOW(), NOW()),
-- 퍼피 어덜트 2.5kg
('55555555-5555-5555-5555-555555555501', '55555555-5555-5555-5555-555555555555', 'COUPANG', 'COUPANG_005', 'https://www.coupang.com/vp/products/123460', 'https://link.coupang.com/a/abc127', true, true, NOW(), NOW()),
-- 퍼피 어덜트 5kg
('66666666-6666-6666-6666-666666666601', '66666666-6666-6666-6666-666666666666', 'COUPANG', 'COUPANG_006', 'https://www.coupang.com/vp/products/123461', 'https://link.coupang.com/a/abc128', true, true, NOW(), NOW()),
-- 네이처스 버라이어티 인스팅트 오리지널 4.5kg
('77777777-7777-7777-7777-777777777701', '77777777-7777-7777-7777-777777777777', 'COUPANG', 'COUPANG_007', 'https://www.coupang.com/vp/products/123462', 'https://link.coupang.com/a/abc129', true, true, NOW(), NOW()),
('77777777-7777-7777-7777-777777777702', '77777777-7777-7777-7777-777777777777', 'NAVER', 'NAVER_002', 'https://shopping.naver.com/catalog/123462', NULL, false, true, NOW(), NOW()),
-- 네이처스 버라이어티 인스팅트 오리지널 11kg
('88888888-8888-8888-8888-888888888801', '88888888-8888-8888-8888-888888888888', 'COUPANG', 'COUPANG_008', 'https://www.coupang.com/vp/products/123463', 'https://link.coupang.com/a/abc130', true, true, NOW(), NOW()),
-- 아카나 그래스랜드 독 6kg
('99999999-9999-9999-9999-999999999901', '99999999-9999-9999-9999-999999999999', 'COUPANG', 'COUPANG_009', 'https://www.coupang.com/vp/products/123464', 'https://link.coupang.com/a/abc131', true, true, NOW(), NOW()),
('99999999-9999-9999-9999-999999999902', '99999999-9999-9999-9999-999999999999', 'BRAND', 'ACANA_001', 'https://www.acana.com/products/123464', NULL, false, true, NOW(), NOW()),
-- 오리젠 오리지널 독 5.4kg
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa01', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'COUPANG', 'COUPANG_010', 'https://www.coupang.com/vp/products/123465', 'https://link.coupang.com/a/abc132', true, true, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa02', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'NAVER', 'NAVER_003', 'https://shopping.naver.com/catalog/123465', NULL, false, true, NOW(), NOW());

-- product_nutrition_facts 데이터
INSERT INTO product_nutrition_facts (product_id, protein_pct, fat_pct, fiber_pct, moisture_pct, ash_pct, kcal_per_100g, calcium_pct, phosphorus_pct, aafco_statement, version, updated_at) VALUES
-- 로얄캐닌 미니 어덜트 3kg
('11111111-1111-1111-1111-111111111111', 28.0, 18.0, 3.5, 8.0, 7.5, 380, 1.0, 0.8, 'AAFCO Dog Food Nutrient Profiles for Adult Maintenance', 1, NOW()),
-- 로얄캐닌 미니 어덜트 7.5kg
('22222222-2222-2222-2222-222222222222', 28.0, 18.0, 3.5, 8.0, 7.5, 380, 1.0, 0.8, 'AAFCO Dog Food Nutrient Profiles for Adult Maintenance', 1, NOW()),
-- 힐스 사이언스 다이어트 어덜트 3kg
('33333333-3333-3333-3333-333333333333', 21.0, 13.0, 4.0, 10.0, 6.0, 360, 0.8, 0.6, 'AAFCO Dog Food Nutrient Profiles for Adult Maintenance', 1, NOW()),
-- 힐스 사이언스 다이어트 어덜트 7kg
('44444444-4444-4444-4444-444444444444', 21.0, 13.0, 4.0, 10.0, 6.0, 360, 0.8, 0.6, 'AAFCO Dog Food Nutrient Profiles for Adult Maintenance', 1, NOW()),
-- 퍼피 어덜트 2.5kg
('55555555-5555-5555-5555-555555555555', 26.0, 15.0, 4.5, 9.0, 7.0, 370, 1.2, 1.0, 'AAFCO Dog Food Nutrient Profiles for Adult Maintenance', 1, NOW()),
-- 퍼피 어덜트 5kg
('66666666-6666-6666-6666-666666666666', 26.0, 15.0, 4.5, 9.0, 7.0, 370, 1.2, 1.0, 'AAFCO Dog Food Nutrient Profiles for Adult Maintenance', 1, NOW()),
-- 네이처스 버라이어티 인스팅트 오리지널 4.5kg
('77777777-7777-7777-7777-777777777777', 38.0, 18.0, 4.0, 10.0, 8.5, 390, 1.5, 1.2, 'AAFCO Dog Food Nutrient Profiles for Adult Maintenance', 1, NOW()),
-- 네이처스 버라이어티 인스팅트 오리지널 11kg
('88888888-8888-8888-8888-888888888888', 38.0, 18.0, 4.0, 10.0, 8.5, 390, 1.5, 1.2, 'AAFCO Dog Food Nutrient Profiles for Adult Maintenance', 1, NOW()),
-- 아카나 그래스랜드 독 6kg
('99999999-9999-9999-9999-999999999999', 33.0, 17.0, 6.0, 12.0, 7.0, 400, 1.3, 1.0, 'AAFCO Dog Food Nutrient Profiles for Adult Maintenance', 1, NOW()),
-- 오리젠 오리지널 독 5.4kg
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 38.0, 18.0, 5.0, 10.0, 8.0, 410, 1.4, 1.1, 'AAFCO Dog Food Nutrient Profiles for Adult Maintenance', 1, NOW());

-- product_allergens 데이터
INSERT INTO product_allergens (product_id, allergen_code, confidence, source) VALUES
-- 로얄캐닌 미니 어덜트 (닭고기, 밀 포함)
('11111111-1111-1111-1111-111111111111', 'CHICKEN', 95, '제품 라벨'),
('11111111-1111-1111-1111-111111111111', 'WHEAT', 90, '제품 라벨'),
('11111111-1111-1111-1111-111111111111', 'CORN', 85, '제품 라벨'),
-- 로얄캐닌 미니 어덜트 7.5kg
('22222222-2222-2222-2222-222222222222', 'CHICKEN', 95, '제품 라벨'),
('22222222-2222-2222-2222-222222222222', 'WHEAT', 90, '제품 라벨'),
('22222222-2222-2222-2222-222222222222', 'CORN', 85, '제품 라벨'),
-- 힐스 사이언스 다이어트 어덜트 (닭고기, 옥수수 포함)
('33333333-3333-3333-3333-333333333333', 'CHICKEN', 95, '제품 라벨'),
('33333333-3333-3333-3333-333333333333', 'CORN', 90, '제품 라벨'),
('33333333-3333-3333-3333-333333333333', 'WHEAT', 80, '제품 라벨'),
-- 힐스 사이언스 다이어트 어덜트 7kg
('44444444-4444-4444-4444-444444444444', 'CHICKEN', 95, '제품 라벨'),
('44444444-4444-4444-4444-444444444444', 'CORN', 90, '제품 라벨'),
('44444444-4444-4444-4444-444444444444', 'WHEAT', 80, '제품 라벨'),
-- 퍼피 어덜트 (닭고기, 쌀 포함)
('55555555-5555-5555-5555-555555555555', 'CHICKEN', 95, '제품 라벨'),
('55555555-5555-5555-5555-555555555555', 'RICE', 90, '제품 라벨'),
('55555555-5555-5555-5555-555555555555', 'CORN', 85, '제품 라벨'),
-- 퍼피 어덜트 5kg
('66666666-6666-6666-6666-666666666666', 'CHICKEN', 95, '제품 라벨'),
('66666666-6666-6666-6666-666666666666', 'RICE', 90, '제품 라벨'),
('66666666-6666-6666-6666-666666666666', 'CORN', 85, '제품 라벨'),
-- 네이처스 버라이어티 인스팅트 오리지널 (닭고기, 계란 포함, 그레인프리)
('77777777-7777-7777-7777-777777777777', 'CHICKEN', 95, '제품 라벨'),
('77777777-7777-7777-7777-777777777777', 'EGG', 90, '제품 라벨'),
-- 네이처스 버라이어티 인스팅트 오리지널 11kg
('88888888-8888-8888-8888-888888888888', 'CHICKEN', 95, '제품 라벨'),
('88888888-8888-8888-8888-888888888888', 'EGG', 90, '제품 라벨'),
-- 아카나 그래스랜드 독 (닭고기, 생선 포함, 그레인프리)
('99999999-9999-9999-9999-999999999999', 'CHICKEN', 95, '제품 라벨'),
('99999999-9999-9999-9999-999999999999', 'FISH', 90, '제품 라벨'),
('99999999-9999-9999-9999-999999999999', 'EGG', 85, '제품 라벨'),
-- 오리젠 오리지널 독 (닭고기, 생선, 계란 포함, 그레인프리)
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'CHICKEN', 95, '제품 라벨'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'FISH', 90, '제품 라벨'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'EGG', 90, '제품 라벨');

-- product_ingredient_profiles 데이터
INSERT INTO product_ingredient_profiles (product_id, ingredients_text, additives_text, parsed, source, version, updated_at) VALUES
-- 로얄캐닌 미니 어덜트 3kg
('11111111-1111-1111-1111-111111111111', 
 '옥수수, 닭고기분, 동물성 지방, 밀글루텐, 쌀, 비트펄프, 동물성 단백질 가수분해물, 어분, 식물성 섬유소, 소금, 콩유, 미네랄, 비타민',
 '항산화제 (비타민E, C), 색소, 방부제',
 '{"main_proteins": ["닭고기분", "동물성 단백질 가수분해물"], "main_carbs": ["옥수수", "밀글루텐", "쌀"], "fats": ["동물성 지방", "콩유"]}',
 '제품 라벨', 1, NOW()),
-- 로얄캐닌 미니 어덜트 7.5kg
('22222222-2222-2222-2222-222222222222',
 '옥수수, 닭고기분, 동물성 지방, 밀글루텐, 쌀, 비트펄프, 동물성 단백질 가수분해물, 어분, 식물성 섬유소, 소금, 콩유, 미네랄, 비타민',
 '항산화제 (비타민E, C), 색소, 방부제',
 '{"main_proteins": ["닭고기분", "동물성 단백질 가수분해물"], "main_carbs": ["옥수수", "밀글루텐", "쌀"], "fats": ["동물성 지방", "콩유"]}',
 '제품 라벨', 1, NOW()),
-- 힐스 사이언스 다이어트 어덜트 3kg
('33333333-3333-3333-3333-333333333333',
 '옥수수, 닭고기분, 동물성 지방, 밀, 쌀, 비트펄프, 닭고기 부산물, 어분, 식물성 섬유소, 소금, 콩유, 미네랄, 비타민',
 '항산화제 (비타민E, C), 방부제',
 '{"main_proteins": ["닭고기분", "닭고기 부산물"], "main_carbs": ["옥수수", "밀", "쌀"], "fats": ["동물성 지방", "콩유"]}',
 '제품 라벨', 1, NOW()),
-- 힐스 사이언스 다이어트 어덜트 7kg
('44444444-4444-4444-4444-444444444444',
 '옥수수, 닭고기분, 동물성 지방, 밀, 쌀, 비트펄프, 닭고기 부산물, 어분, 식물성 섬유소, 소금, 콩유, 미네랄, 비타민',
 '항산화제 (비타민E, C), 방부제',
 '{"main_proteins": ["닭고기분", "닭고기 부산물"], "main_carbs": ["옥수수", "밀", "쌀"], "fats": ["동물성 지방", "콩유"]}',
 '제품 라벨', 1, NOW()),
-- 퍼피 어덜트 2.5kg
('55555555-5555-5555-5555-555555555555',
 '쌀, 닭고기분, 옥수수, 동물성 지방, 비트펄프, 닭고기 부산물, 어분, 식물성 섬유소, 소금, 콩유, 미네랄, 비타민',
 '항산화제 (비타민E, C), 방부제',
 '{"main_proteins": ["닭고기분", "닭고기 부산물"], "main_carbs": ["쌀", "옥수수"], "fats": ["동물성 지방", "콩유"]}',
 '제품 라벨', 1, NOW()),
-- 퍼피 어덜트 5kg
('66666666-6666-6666-6666-666666666666',
 '쌀, 닭고기분, 옥수수, 동물성 지방, 비트펄프, 닭고기 부산물, 어분, 식물성 섬유소, 소금, 콩유, 미네랄, 비타민',
 '항산화제 (비타민E, C), 방부제',
 '{"main_proteins": ["닭고기분", "닭고기 부산물"], "main_carbs": ["쌀", "옥수수"], "fats": ["동물성 지방", "콩유"]}',
 '제품 라벨', 1, NOW()),
-- 네이처스 버라이어티 인스팅트 오리지널 4.5kg
('77777777-7777-7777-7777-777777777777',
 '닭고기, 닭고기육분, 계란, 완두콩, 병아리콩, 닭고기 지방, 완두콩 단백질, 감자, 고구마, 사과, 블루베리, 미네랄, 비타민',
 '항산화제 (비타민E, C), 천연 방부제',
 '{"main_proteins": ["닭고기", "닭고기육분", "계란", "완두콩 단백질"], "main_carbs": ["완두콩", "병아리콩", "감자", "고구마"], "fats": ["닭고기 지방"]}',
 '제품 라벨', 1, NOW()),
-- 네이처스 버라이어티 인스팅트 오리지널 11kg
('88888888-8888-8888-8888-888888888888',
 '닭고기, 닭고기육분, 계란, 완두콩, 병아리콩, 닭고기 지방, 완두콩 단백질, 감자, 고구마, 사과, 블루베리, 미네랄, 비타민',
 '항산화제 (비타민E, C), 천연 방부제',
 '{"main_proteins": ["닭고기", "닭고기육분", "계란", "완두콩 단백질"], "main_carbs": ["완두콩", "병아리콩", "감자", "고구마"], "fats": ["닭고기 지방"]}',
 '제품 라벨', 1, NOW()),
-- 아카나 그래스랜드 독 6kg
('99999999-9999-9999-9999-999999999999',
 '닭고기육, 닭고기육분, 칠면조육분, 완두콩, 병아리콩, 닭고기 지방, 연어, 계란, 감자, 고구마, 사과, 블루베리, 미네랄, 비타민',
 '항산화제 (비타민E, C), 천연 방부제',
 '{"main_proteins": ["닭고기육", "닭고기육분", "칠면조육분", "연어", "계란"], "main_carbs": ["완두콩", "병아리콩", "감자", "고구마"], "fats": ["닭고기 지방"]}',
 '제품 라벨', 1, NOW()),
-- 오리젠 오리지널 독 5.4kg
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 '닭고기육, 칠면조육, 계란, 연어, 닭고기육분, 칠면조육분, 연어육분, 완두콩, 병아리콩, 닭고기 지방, 연어 기름, 감자, 고구마, 사과, 블루베리, 미네랄, 비타민',
 '항산화제 (비타민E, C), 천연 방부제',
 '{"main_proteins": ["닭고기육", "칠면조육", "계란", "연어", "닭고기육분", "칠면조육분", "연어육분"], "main_carbs": ["완두콩", "병아리콩", "감자", "고구마"], "fats": ["닭고기 지방", "연어 기름"]}',
 '제품 라벨', 1, NOW());
