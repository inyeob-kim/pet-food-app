import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import '../models/recommendation_dto.dart';
import '../models/product_dto.dart';
import '../mock/mock_data.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  Future<RecommendationResponseDto> getRecommendations(String petId) async {
    try {
      final response = await _apiClient.get(
        Endpoints.productRecommendations,
        queryParameters: {'pet_id': petId},
      );

      return RecommendationResponseDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        // Mock 데이터 fallback
        return _getMockRecommendations(petId);
      } else if (e.response != null && e.response!.statusCode == 404) {
        // Mock 데이터 fallback
        return _getMockRecommendations(petId);
      } else {
        // Mock 데이터 fallback
        return _getMockRecommendations(petId);
      }
    } catch (e) {
      // Mock 데이터 fallback
      return _getMockRecommendations(petId);
    }
  }

  Future<ProductDto> getProduct(String productId) async {
    try {
      final response = await _apiClient.get(Endpoints.product(productId));
      return ProductDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        // Mock 데이터 fallback
        return _getMockProduct(productId);
      } else if (e.response != null && e.response!.statusCode == 404) {
        // Mock 데이터 fallback
        return _getMockProduct(productId);
      } else {
        // Mock 데이터 fallback
        return _getMockProduct(productId);
      }
    } catch (e) {
      // Mock 데이터 fallback
      return _getMockProduct(productId);
    }
  }

  RecommendationResponseDto _getMockRecommendations(String petId) {
    return MockData.getRecommendations(petId);
  }

  ProductDto _getMockProduct(String id) {
    return MockData.getProduct(id);
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProductRepository(apiClient);
});
