import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/error/exceptions.dart';
import '../models/tracking_dto.dart';

class TrackingRepository {
  final ApiClient _apiClient;

  TrackingRepository(this._apiClient);

  Future<TrackingDto> createTracking({
    required String productId,
    required String petId,
    int? targetPrice,
  }) async {
    try {
      final response = await _apiClient.post(
        Endpoints.trackings,
        data: {
          'product_id': productId,
          'pet_id': petId,
          if (targetPrice != null) 'target_price': targetPrice,
        },
      );

      return TrackingDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        // Mock 성공 처리 (서버 없을 때) - 실제로는 에러를 던져야 하지만 MVP에서는 허용
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

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TrackingRepository(apiClient);
});
