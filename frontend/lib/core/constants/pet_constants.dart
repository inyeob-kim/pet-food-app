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

  /// 나이 단계 텍스트 변환
  static String? getAgeStageText(String? ageStage) {
    if (ageStage == null) return null;
    switch (ageStage.toUpperCase()) {
      case 'PUPPY':
        return '강아지';
      case 'ADULT':
        return '성견';
      case 'SENIOR':
        return '노견';
      default:
        return ageStage;
    }
  }

  /// 건강 관심사 이름 매핑
  static const Map<String, String> healthConcernNames = {
    'OBESITY': '비만',
    'SKIN': '피부',
    'DIGESTIVE': '소화',
    'JOINT': '관절',
    'DENTAL': '치아',
    'URINARY': '요로',
    'HEART': '심장',
    'ALLERGY': '알레르기',
  };

  /// 알레르겐 이름 매핑
  static const Map<String, String> allergenNames = {
    'CHICKEN': '닭고기',
    'BEEF': '소고기',
    'PORK': '돼지고기',
    'FISH': '생선',
    'EGG': '계란',
    'DAIRY': '유제품',
    'WHEAT': '밀',
    'SOY': '대두',
    'CORN': '옥수수',
  };
}

