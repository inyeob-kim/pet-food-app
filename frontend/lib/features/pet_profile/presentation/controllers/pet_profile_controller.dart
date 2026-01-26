import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/pet_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/providers/pet_id_provider.dart';

class PetProfileState {
  final bool isLoading;
  final String? error;
  final String? petId;

  PetProfileState({
    this.isLoading = false,
    this.error,
    this.petId,
  });

  PetProfileState copyWith({
    bool? isLoading,
    String? error,
    String? petId,
  }) {
    return PetProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      petId: petId ?? this.petId,
    );
  }
}

class PetProfileController extends StateNotifier<PetProfileState> {
  final PetRepository _petRepository;
  final Ref _ref;

  PetProfileController(this._petRepository, this._ref) : super(PetProfileState());

  Future<void> createPet({
    required String breedCode,
    required String weightBucket,
    required String ageStage,
    bool isPrimary = true,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pet = await _petRepository.createPet(
        breedCode: breedCode,
        weightBucket: weightBucket,
        ageStage: ageStage,
        isPrimary: isPrimary,
      );

      // 생성된 petId를 프로바이더에 저장
      _ref.read(currentPetIdProvider.notifier).state = pet.id;

      state = state.copyWith(
        isLoading: false,
        petId: pet.id,
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

final petProfileControllerProvider =
    StateNotifierProvider<PetProfileController, PetProfileState>((ref) {
  final petRepository = ref.watch(petRepositoryProvider);
  return PetProfileController(petRepository, ref);
});
