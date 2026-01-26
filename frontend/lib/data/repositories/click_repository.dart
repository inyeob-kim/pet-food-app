import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/error/exceptions.dart';
import '../models/click_dto.dart';
import '../../core/constants/enums.dart';

class ClickRepository {
  final ApiClient _apiClient;

  ClickRepository(this._apiClient);

  Future<ClickDto> createClick({
    String? petId,
    required String productId,
    required String offerId,
    required ClickSource source,
  }) async {
    try {
      final response = await _apiClient.post(
        Endpoints.clicks,
        data: {
          if (petId != null) 'pet_id': petId,
          'product_id': productId,
          'offer_id': offerId,
          'source': source.value,
        },
      );

      return ClickDto.fromJson(response.data as Map<String, dynamic>);
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

final clickRepositoryProvider = Provider<ClickRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ClickRepository(apiClient);
});

