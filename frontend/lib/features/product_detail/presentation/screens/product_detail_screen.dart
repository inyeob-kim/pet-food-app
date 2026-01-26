import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/providers/pet_id_provider.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productDetailControllerProvider(widget.productId).notifier).loadProduct(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailControllerProvider(widget.productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('상품 상세'),
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, ProductDetailState state) {
    if (state.isLoading) {
      return const LoadingWidget();
    }

    if (state.error != null && state.product == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(productDetailControllerProvider(widget.productId).notifier).loadProduct(widget.productId);
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    final product = state.product;
    if (product == null) {
      return const Center(child: Text('상품 정보를 불러올 수 없습니다.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.pets, size: 80),
          ),
          const SizedBox(height: 24),
          Text(
            product.productName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            product.brandName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          if (product.sizeLabel != null) ...[
            const SizedBox(height: 4),
            Text(
              product.sizeLabel!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '가격 정보',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '평균 가격 대비 최저가',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '최근 14일 평균 대비 5% 할인',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (state.trackingCreated)
            Card(
              color: Colors.green[50],
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('가격 알림이 설정되었습니다'),
                  ],
                ),
              ),
            )
          else
            PrimaryButton(
              text: '가격 알림 받기',
              isLoading: state.isTrackingLoading,
              onPressed: () async {
                final petId = ref.read(currentPetIdProvider);
                if (petId == null) {
                  // TODO: 에러 처리 (프로필 먼저 등록하라는 메시지)
                  return;
                }
                await ref.read(productDetailControllerProvider(widget.productId).notifier).createTracking(
                      widget.productId,
                      petId,
                    );
              },
            ),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                state.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
