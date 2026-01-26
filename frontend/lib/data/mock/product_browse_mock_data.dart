import '../models/product_dto.dart';
import '../../core/constants/enums.dart';

/// 사료 선택 / 대표 사료 둘러보기 더미 데이터
class ProductBrowseMockData {
  /// 대표 사료 그리드 (200개 - 실제로는 일부만 표시)
  static List<ProductCardData> get popularProducts {
    final brands = [
      '로얄캐닌', '힐스', '퍼피', '네츄럴밸런스', '오리젠', '아카나', '웰니스', '프로플랜',
      '유카누바', '피트앤포', '퍼피쵸이스', '뉴트로', '블루버팔로', '어드밴스', '시저',
    ];
    
    final productNames = [
      '미니 어덜트', '사이언스 다이어트', '초이스', '리미티드 인그리디언트', '오리지널 독',
      '클래식 레드', '코어 어덜트', '옵티헬스', '그레인프리', '스몰브리드',
      '퍼피', '어덜트', '시니어', '다이어트', '피부건강', '장건강', '관절건강',
    ];
    
    final sizes = ['2kg', '3kg', '4.5kg', '5kg', '6kg', '7kg', '10kg', '12kg'];
    
    final tags = [
      ['많이 선택됨', '인기'],
      ['신제품'],
      ['할인중'],
      ['많이 선택됨'],
      ['인기', '할인중'],
      ['신제품', '많이 선택됨'],
    ];

    final products = <ProductCardData>[];
    
    for (int i = 0; i < 200; i++) {
      final brandIndex = i % brands.length;
      final nameIndex = i % productNames.length;
      final sizeIndex = i % sizes.length;
      final tagIndex = i % tags.length;
      
      products.add(ProductCardData(
        product: ProductDto(
          id: 'browse-prod-${i + 1}',
          brandName: brands[brandIndex],
          productName: productNames[nameIndex],
          sizeLabel: sizes[sizeIndex],
          isActive: true,
        ),
        tags: tags[tagIndex],
        isPopular: i % 3 == 0,
        isNew: i % 5 == 0,
        isOnSale: i % 4 == 0,
      ));
    }
    
    return products;
  }

  /// 필터 옵션
  static FilterOptions get filterOptions {
    return FilterOptions(
      ageStages: [AgeStage.puppy, AgeStage.adult, AgeStage.senior],
      weightBuckets: ['소형 (5kg 이하)', '중형 (5-15kg)', '대형 (15kg 이상)'],
      needs: ['피부건강', '장건강', '다이어트', '관절건강', '털빠짐', '알레르기'],
    );
  }
}

/// 상품 카드 데이터 (UI용)
class ProductCardData {
  final ProductDto product;
  final List<String> tags;
  final bool isPopular;
  final bool isNew;
  final bool isOnSale;

  ProductCardData({
    required this.product,
    required this.tags,
    this.isPopular = false,
    this.isNew = false,
    this.isOnSale = false,
  });
}

/// 필터 옵션
class FilterOptions {
  final List<AgeStage> ageStages;
  final List<String> weightBuckets;
  final List<String> needs;

  FilterOptions({
    required this.ageStages,
    required this.weightBuckets,
    required this.needs,
  });
}
