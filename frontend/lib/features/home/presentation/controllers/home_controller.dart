import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/product_repository.dart';
import '../../../../data/models/recommendation_dto.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/providers/pet_id_provider.dart';

enum HomeEmptyStateType {
  none, // 데이터 있음
  noProfile, // 프로필 없음 (중립)
  error, // 서버/네트워크 오류 (빨간 톤)
}

class HomeState {
  final RecommendationResponseDto? recommendations;
  final bool isLoading;
  final String? error;
  final HomeEmptyStateType emptyStateType;

  HomeState({
    this.recommendations,
    this.isLoading = false,
    this.error,
    this.emptyStateType = HomeEmptyStateType.none,
  });

  bool get hasData => recommendations != null && (recommendations?.items.isNotEmpty ?? false);
  bool get isNoProfile => emptyStateType == HomeEmptyStateType.noProfile;
  bool get isError => emptyStateType == HomeEmptyStateType.error;

  HomeState copyWith({
    RecommendationResponseDto? recommendations,
    bool? isLoading,
    String? error,
    HomeEmptyStateType? emptyStateType,
  }) {
    return HomeState(
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      emptyStateType: emptyStateType ?? this.emptyStateType,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  final ProductRepository _productRepository;
  final Ref _ref;

  HomeController(this._productRepository, this._ref) : super(HomeState());

  Future<void> loadRecommendations() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      emptyStateType: HomeEmptyStateType.none,
    );

    try {
      final petId = _ref.read(currentPetIdProvider);
      if (petId == null) {
        state = state.copyWith(
          isLoading: false,
          emptyStateType: HomeEmptyStateType.noProfile,
        );
        return;
      }

      final recommendations = await _productRepository.getRecommendations(petId);
      state = state.copyWith(
        isLoading: false,
        recommendations: recommendations,
        emptyStateType: (recommendations.items.isEmpty)
            ? HomeEmptyStateType.noProfile
            : HomeEmptyStateType.none,
      );
    } catch (e) {
      final failure = e is Exception
          ? handleException(e)
          : ServerFailure('알 수 없는 오류가 발생했습니다: ${e.toString()}');
      state = state.copyWith(
        isLoading: false,
        error: failure.message,
        emptyStateType: HomeEmptyStateType.error,
      );
    }
  }
}

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return HomeController(productRepository, ref);
});
