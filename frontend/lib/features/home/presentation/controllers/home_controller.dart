import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/product_repository.dart';
import '../../../../data/models/recommendation_dto.dart';
import '../../../../data/models/recommendation_extensions.dart';
import '../../../../data/models/pet_summary_dto.dart';
import '../../../../domain/services/pet_service.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/providers/pet_id_provider.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/storage_keys.dart';

/// 홈 화면 상태 타입 (A/B/C 분기)
enum HomeStateType {
  loading, // 로딩 중
  hasPet, // B: primary pet 존재 → 정상 홈
  noPet, // C: pet 없음 → Empty State
  error, // 에러 상태
}

class HomeState {
  final HomeStateType stateType;
  final PetSummaryDto? petSummary;
  final RecommendationResponseDto? recommendations;
  final bool isLoadingRecommendations;
  final String? error;
  // UPDATED: Dynamic recommendation UI to reduce reload fatigue
  final DateTime? lastRecommendedAt;
  final bool hasRecentRecommendation;
  final String? userNickname; // 유저 닉네임

  HomeState({
    HomeStateType? stateType,
    this.petSummary,
    this.recommendations,
    this.isLoadingRecommendations = false,
    this.error,
    this.lastRecommendedAt,
    this.hasRecentRecommendation = false,
    this.userNickname,
  }) : stateType = stateType ?? HomeStateType.loading;

  bool get hasPet => stateType == HomeStateType.hasPet && petSummary != null;
  bool get isNoPet => stateType == HomeStateType.noPet;
  bool get isError => stateType == HomeStateType.error;
  bool get isLoading => stateType == HomeStateType.loading;
  bool get hasRecommendations => recommendations != null && recommendations!.items.isNotEmpty;

  // UPDATED: Dynamic recommendation UI to reduce reload fatigue - 동적 버튼 텍스트
  String get recommendationActionText {
    if (!hasRecommendations) return "지금 추천받기";
    if (hasRecentRecommendation) return "최근 추천 보기";
    if (lastRecommendedAt != null) {
      final daysSince = DateTime.now().difference(lastRecommendedAt!).inDays;
      if (daysSince <= 14) {
        return "업데이트된 추천 확인하기";
      }
    }
    return "펫 상태 바뀌었나요? 다시 추천받기";
  }

  HomeState copyWith({
    HomeStateType? stateType,
    PetSummaryDto? petSummary,
    RecommendationResponseDto? recommendations,
    bool? isLoadingRecommendations,
    String? error,
    DateTime? lastRecommendedAt,
    bool? hasRecentRecommendation,
    String? userNickname,
  }) {
    return HomeState(
      stateType: stateType ?? this.stateType,
      petSummary: petSummary ?? this.petSummary,
      recommendations: recommendations ?? this.recommendations,
      isLoadingRecommendations: isLoadingRecommendations ?? this.isLoadingRecommendations,
      error: error ?? this.error,
      lastRecommendedAt: lastRecommendedAt ?? this.lastRecommendedAt,
      hasRecentRecommendation: hasRecentRecommendation ?? this.hasRecentRecommendation,
      userNickname: userNickname ?? this.userNickname,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  final ProductRepository _productRepository;
  final PetService _petService;
  final Ref _ref;

  HomeController(this._productRepository, this._petService, this._ref)
      : super(HomeState(stateType: HomeStateType.loading));

  /// 홈 화면 초기화 (primary pet 조회만, 추천은 버튼 클릭 시 로드)
  Future<void> initialize() async {
    state = state.copyWith(stateType: HomeStateType.loading);
    print('[HomeController] initialize() 시작');

    try {
      // 1. Primary Pet 조회
      print('[HomeController] Primary Pet 조회 시작');
      final petSummary = await _petService.getPrimaryPetSummary();
      print('[HomeController] Primary Pet 조회 결과: ${petSummary != null ? "있음 (${petSummary.name})" : "없음"}');

      if (petSummary == null) {
        // C 상태: pet 없음
        state = state.copyWith(
          stateType: HomeStateType.noPet,
          petSummary: null,
        );
        return;
      }

      // 2. Pet ID를 provider에 저장
      _ref.read(currentPetIdProvider.notifier).state = petSummary.petId;

      // 3. 유저 닉네임 로드
      String? nickname;
      try {
        nickname = await SecureStorage.read(StorageKeys.draftNickname);
      } catch (e) {
        print('[HomeController] 닉네임 로드 실패: $e');
      }
      
      // 4. B 상태: pet 존재 (추천은 버튼 클릭 시 로드)
      state = state.copyWith(
        stateType: HomeStateType.hasPet,
        petSummary: petSummary,
        isLoadingRecommendations: false,  // 초기에는 로딩하지 않음
        recommendations: null,  // 초기에는 추천 없음
        userNickname: nickname,
      );
    } catch (e) {
      final failure = e is Exception
          ? handleException(e)
          : ServerFailure('펫 정보를 불러오는데 실패했습니다. 잠시 후 다시 시도해주세요.');
      state = state.copyWith(
        stateType: HomeStateType.error,
        error: failure.message,
      );
    }
  }

  /// 추천 데이터 로드
  // UPDATED: Dynamic recommendation UI to reduce reload fatigue - 캐싱 정보 처리 추가
  Future<void> _loadRecommendations(String petId, {bool force = false}) async {
    final startTime = DateTime.now();
    print('[HomeController] 📡 추천 데이터 로드 시작: petId=$petId, force=$force');
    state = state.copyWith(isLoadingRecommendations: true); // 로딩 상태 시작
    
    try {
      print('[HomeController] 📞 ProductRepository.getRecommendations() 호출');
      final recommendations = await _productRepository.getRecommendations(petId);
      final duration = DateTime.now().difference(startTime);
      print('[HomeController] ✅ 추천 데이터 로드 완료: ${recommendations.items.length}개 상품, isCached=${recommendations.isCached}, 소요시간=${duration.inMilliseconds}ms');
      print('[HomeController] 📊 추천 상품 요약:');
      for (var i = 0; i < recommendations.items.length && i < 3; i++) {
        final item = recommendations.items[i];
        print('[HomeController]   ${i + 1}. ${item.product.brandName} ${item.product.productName} (점수: ${item.matchScore.toStringAsFixed(1)}, 안전: ${item.safetyScore.toStringAsFixed(1)}, 적합: ${item.fitnessScore.toStringAsFixed(1)})');
      }
      
      // UPDATED: Dynamic recommendation UI to reduce reload fatigue - 캐싱 정보 기반 상태 업데이트
      // extension을 사용하여 hasRecent 계산
      state = state.copyWith(
        recommendations: recommendations,
        isLoadingRecommendations: false,
        lastRecommendedAt: recommendations.lastRecommendedAt,
        hasRecentRecommendation: recommendations.hasRecentRecommendation,
      );
      print('[HomeController] ✅ 상태 업데이트 완료: isLoadingRecommendations=false, hasRecentRecommendation=${recommendations.hasRecentRecommendation}, lastRecommendedAt=${recommendations.lastRecommendedAt}');
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime);
      print('[HomeController] ❌ 추천 데이터 로드 실패: error=$e, 소요시간=${duration.inMilliseconds}ms');
      print('[HomeController] ❌ StackTrace: $stackTrace');
      final failure = e is Exception
          ? handleException(e)
          : ServerFailure('추천 상품을 불러오는데 실패했습니다. 잠시 후 다시 시도해주세요.');
      state = state.copyWith(
        isLoadingRecommendations: false,
        error: failure.message,
        // 추천 실패해도 홈은 표시 (pet은 있으므로)
      );
      print('[HomeController] ⚠️ 상태 업데이트: isLoadingRecommendations=false, error=${failure.message}');
    }
  }

  /// 추천 로드 (버튼 클릭 시 호출)
  // UPDATED: Dynamic recommendation UI to reduce reload fatigue - force 파라미터 추가
  Future<void> loadRecommendations({bool force = false}) async {
    print('[HomeController] 🎯 loadRecommendations() 호출됨: force=$force');
    final petSummary = state.petSummary;
    if (petSummary == null) {
      print('[HomeController] ⚠️ petSummary가 null입니다. 추천을 로드할 수 없습니다.');
      return;
    }
    
    // 이미 로딩 중이면 중복 호출 방지
    if (state.isLoadingRecommendations) {
      print('[HomeController] ⏸️ 이미 로딩 중입니다. 중복 호출 방지.');
      return;
    }
    
    // UPDATED: Dynamic recommendation UI to reduce reload fatigue - 최근 추천이 있고 force가 false면 스킵 가능
    if (!force && state.hasRecentRecommendation && state.hasRecommendations) {
      print('[HomeController] 💾 최근 추천이 있어서 API 호출 스킵 (force=false)');
      // 상태만 업데이트 (이미 recommendations가 있음)
      return;
    }
    
    print('[HomeController] ▶️ _loadRecommendations() 호출: petId=${petSummary.petId}, force=$force');
    await _loadRecommendations(petSummary.petId, force: force);
  }

  /// 추천 새로고침
  Future<void> refreshRecommendations() async {
    final petSummary = state.petSummary;
    if (petSummary != null) {
      await _loadRecommendations(petSummary.petId);
    }
  }
  
  /// 추천 결과 직접 설정 (애니메이션 화면에서 사용)
  void setRecommendations(RecommendationResponseDto recommendations) {
    // extension을 사용하여 hasRecent 계산
    state = state.copyWith(
      recommendations: recommendations,
      isLoadingRecommendations: false,
      lastRecommendedAt: recommendations.lastRecommendedAt,
      hasRecentRecommendation: recommendations.hasRecentRecommendation,
    );
  }
}

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  final petService = ref.watch(petServiceProvider);
  return HomeController(productRepository, petService, ref);
});
