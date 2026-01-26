/// 반려동물 관련 상수 (도메인 데이터)

class PetConstants {
  /// 견종 목록
  static const List<String> breeds = [
    '비글',
    '골든 리트리버',
    '래브라도 리트리버',
    '퍼그',
    '치와와',
    '포메라니안',
  ];

  /// 체중 구간 목록
  static const List<String> weightBuckets = [
    '5kg 이하',
    '5-10kg',
    '10-15kg',
    '15-20kg',
    '20kg 이상',
  ];

  /// 나이 단계 목록
  static const List<String> ageStages = [
    'PUPPY',
    'ADULT',
    'SENIOR',
  ];
}

