import '../models/pet_dto.dart';
import '../../core/constants/enums.dart';

/// 마이 화면 더미 데이터
class MeMockData {
  /// 반려동물 프로필
  static PetDto get petProfile {
    return PetDto(
      id: 'pet-001',
      userId: 'user-001',
      name: '뽀삐',
      breedCode: 'GOLDEN_RETRIEVER',
      weightBucketCode: '10-15kg',
      ageStage: AgeStage.adult,
      isNeutered: true,
      isPrimary: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    );
  }

  /// 견종 이름 변환
  static String getBreedName(String breedCode) {
    final breedMap = {
      'GOLDEN_RETRIEVER': '골든 리트리버',
      'LABRADOR': '래브라도 리트리버',
      'POODLE': '푸들',
      'BEAGLE': '비글',
      'BULLDOG': '불독',
      'SHIBA': '시바견',
      'MALTESE': '말티즈',
      'CHIHUAHUA': '치와와',
    };
    return breedMap[breedCode] ?? breedCode;
  }

  /// 알림 설정
  static NotificationSettings get notificationSettings {
    return NotificationSettings(
      priceAlerts: true,
      pushNotifications: true,
      lowStockAlerts: true,
      emailAlerts: false,
    );
  }

  /// 포인트
  static int get points => 1250;
}

/// 알림 설정
class NotificationSettings {
  final bool priceAlerts;
  final bool pushNotifications;
  final bool lowStockAlerts;
  final bool emailAlerts;

  NotificationSettings({
    required this.priceAlerts,
    required this.pushNotifications,
    required this.lowStockAlerts,
    required this.emailAlerts,
  });
}
