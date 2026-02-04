import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/router/route_paths.dart';
import '../../../../../domain/services/pet_service.dart';

/// 맞춤 추천 배너 카드 (추천 플랫폼 스타일)
class RecommendBannerCard extends ConsumerWidget {
  const RecommendBannerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 펫 프로필 확인
    final petService = ref.watch(petServiceProvider);
    final petSummaryFuture = petService.getPrimaryPetSummary();

    return FutureBuilder(
      future: petSummaryFuture,
      builder: (context, snapshot) {
        final hasPet = snapshot.hasData && snapshot.data != null;
        final petName = snapshot.data?.name;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: InkWell(
              onTap: () => _handleTap(context, hasPet),
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade50,
                      Colors.grey.shade100.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 메인 문구
                          Text(
                            hasPet && petName != null
                                ? '$petName에게 맞는 사료 추천 받아볼까요?'
                                : '프로필 등록하고 추천받기',
                            style: AppTypography.h3.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 보조 텍스트
                          Text(
                            '알러지/피부/다이어트 기준으로 골라드려요',
                            style: AppTypography.body2.copyWith(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // CTA 버튼
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                      child: Text(
                        hasPet ? '추천 시작' : '프로필 등록',
                        style: AppTypography.button.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTap(BuildContext context, bool hasPet) {
    if (hasPet) {
      // 추천 플로우로 이동 (TODO: 추천 페이지 경로 추가)
      // context.push(RoutePaths.recommendation);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('추천 플로우 준비중')),
      );
    } else {
      // 펫 프로필 등록으로 이동
      context.push(RoutePaths.petProfile);
    }
  }
}
