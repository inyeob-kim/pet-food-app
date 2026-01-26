import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/error/exceptions.dart';
import '../models/alert_dto.dart';
import '../../core/constants/enums.dart';

class AlertRepository {
  final ApiClient _apiClient;

  AlertRepository(this._apiClient);

  Future<AlertDto> createAlert({
    required String trackingId,
    required AlertRuleType ruleType,
    int? targetPrice,
    int? cooldownHours,
  }) async {
    try {
      final response = await _apiClient.post(
        Endpoints.alerts,
        data: {
          'tracking_id': trackingId,
          'rule_type': ruleType.value,
          if (targetPrice != null) 'target_price': targetPrice,
          if (cooldownHours != null) 'cooldown_hours': cooldownHours,
        },
      );

      return AlertDto.fromJson(response.data as Map<String, dynamic>);
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

final alertRepositoryProvider = Provider<AlertRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AlertRepository(apiClient);
});

