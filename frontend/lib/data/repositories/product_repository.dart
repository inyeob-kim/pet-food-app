import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import '../models/recommendation_dto.dart';
import '../models/product_dto.dart';
import '../../core/constants/enums.dart';

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
    return RecommendationResponseDto(
      petId: petId,
      items: [
        RecommendationItemDto(
          product: ProductDto(
            id: '00000000-0000-0000-0000-000000000001',
            brandName: '로얄캐닌',
            productName: '미니 어덜트',
            sizeLabel: '3kg',
            isActive: true,
          ),
          offerMerchant: Merchant.coupang,
          currentPrice: 35000,
          avgPrice: 38000,
          deltaPercent: -7.89,
          isNewLow: true,
        ),
        RecommendationItemDto(
          product: ProductDto(
            id: '00000000-0000-0000-0000-000000000002',
            brandName: '힐스',
            productName: '사이언스 다이어트',
            sizeLabel: '5kg',
            isActive: true,
          ),
          offerMerchant: Merchant.naver,
          currentPrice: 45000,
          avgPrice: 45000,
          deltaPercent: 0.0,
          isNewLow: false,
        ),
        RecommendationItemDto(
          product: ProductDto(
            id: '00000000-0000-0000-0000-000000000003',
            brandName: '퍼피',
            productName: '초이스',
            sizeLabel: '2kg',
            isActive: true,
          ),
          offerMerchant: Merchant.coupang,
          currentPrice: 28000,
          avgPrice: 30000,
          deltaPercent: -6.67,
          isNewLow: true,
        ),
      ],
    );
  }

  ProductDto _getMockProduct(String id) {
    return ProductDto(
      id: id,
      brandName: '로얄캐닌',
      productName: '미니 어덜트',
      sizeLabel: '3kg',
      isActive: true,
    );
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProductRepository(apiClient);
});
