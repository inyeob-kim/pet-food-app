import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/product_repository.dart';
import '../../../../data/models/recommendation_dto.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/providers/pet_id_provider.dart';

class HomeState {
  final RecommendationResponseDto? recommendations;
  final bool isLoading;
  final String? error;

  HomeState({
    this.recommendations,
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    RecommendationResponseDto? recommendations,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  final ProductRepository _productRepository;
  final Ref _ref;

  HomeController(this._productRepository, this._ref) : super(HomeState());

  Future<void> loadRecommendations() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final petId = _ref.read(currentPetIdProvider);
      if (petId == null) {
        state = state.copyWith(
          isLoading: false,
          error: '반려동물 정보가 없습니다. 프로필을 먼저 등록해주세요.',
        );
        return;
      }

      final recommendations = await _productRepository.getRecommendations(petId);
      state = state.copyWith(
        isLoading: false,
        recommendations: recommendations,
      );
    } catch (e) {
      Failure failure;
      if (e is Exception) {
        failure = handleException(e);
      } else {
        failure = ServerFailure('알 수 없는 오류가 발생했습니다: ${e.toString()}');
      }
      state = state.copyWith(
        isLoading: false,
        error: failure.message,
      );
    }
  }
}

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return HomeController(productRepository, ref);
});
