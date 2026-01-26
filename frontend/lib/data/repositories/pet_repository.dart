import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/error/exceptions.dart';
import '../models/pet_dto.dart';

class PetRepository {
  final ApiClient _apiClient;

  PetRepository(this._apiClient);

  Future<PetDto> createPet({
    required String breedCode,
    required String weightBucket,
    required String ageStage,
    bool isPrimary = false,
  }) async {
    try {
      final response = await _apiClient.post(
        Endpoints.pets,
        data: {
          'breed_code': breedCode,
          'weight_bucket_code': weightBucket,
          'age_stage': ageStage,
          'is_primary': isPrimary,
        },
      );

      // 응답 데이터 타입 확인 및 변환
      final responseData = response.data;
      
      // 디버깅: 응답 데이터 출력
      print('[PetRepository] Response data type: ${responseData.runtimeType}');
      print('[PetRepository] Response data: $responseData');
      
      if (responseData is! Map<String, dynamic>) {
        throw ServerException('서버 응답 형식이 올바르지 않습니다. 타입: ${responseData.runtimeType}');
      }

      try {
        return PetDto.fromJson(responseData);
      } catch (e, stackTrace) {
        print('[PetRepository] JSON 파싱 에러: $e');
        print('[PetRepository] Stack trace: $stackTrace');
        print('[PetRepository] 문제가 된 데이터: $responseData');
        rethrow;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('네트워크 연결 시간이 초과되었습니다.');
      } else if (e.response != null) {
        throw ServerException(
          e.response?.data['detail'] as String? ?? '서버 오류가 발생했습니다.',
        );
      } else {
        throw NetworkException('네트워크 오류가 발생했습니다.');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('알 수 없는 오류가 발생했습니다.');
    }
  }
}

final petRepositoryProvider = Provider<PetRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PetRepository(apiClient);
});
