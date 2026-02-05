import 'package:flutter/material.dart';
import '../../../../../ui/widgets/figma_app_bar.dart';
import '../../../../../ui/widgets/figma_primary_button.dart';
import '../../../../../app/theme/app_typography.dart';

/// Figma 디자인 기반 Benefits Screen
class BenefitsScreen extends StatelessWidget {
  const BenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final missions = [
      MissionData(
        id: 1,
        title: '제품 3개 관심 추가',
        reward: 100,
        completed: true,
        current: 3,
        total: 3,
      ),
      MissionData(
        id: 2,
        title: '프로필 완성',
        reward: 200,
        completed: true,
        current: 1,
        total: 1,
      ),
      MissionData(
        id: 3,
        title: '친구에게 공유',
        reward: 500,
        completed: false,
        current: 0,
        total: 1,
      ),
      MissionData(
        id: 4,
        title: '리뷰 작성',
        reward: 300,
        completed: false,
        current: 0,
        total: 1,
      ),
      MissionData(
        id: 5,
        title: '첫 구매하기',
        reward: 1000,
        completed: false,
        current: 0,
        total: 1,
      ),
    ];

    final totalPoints = 1850;
    final earnedPoints = missions
        .where((m) => m.completed)
        .fold(0, (sum, m) => sum + m.reward);
    final availablePoints = missions.fold(0, (sum, m) => sum + m.reward) - earnedPoints;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const FigmaAppBar(title: '혜택'),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Hero Point Section
                      Row(
                        children: [
                          const Icon(
                            Icons.card_giftcard,
                            size: 24,
                            color: Color(0xFF2563EB),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '내 포인트',
                            style: AppTypography.body.copyWith(
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        totalPoints.toString().replaceAllMapped(
                          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                          (match) => '${match[1]},',
                        ),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '추가로 ${availablePoints.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')} 포인트 획득 가능',
                        style: AppTypography.body.copyWith(
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Mission List
                      Text(
                        '미션을 완료하여 포인트 획득',
                        style: AppTypography.body.copyWith(
                          color: const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...missions.map((mission) => _buildMissionCard(mission)),
                      const SizedBox(height: 32),
                      // Points Usage
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '포인트 사용 방법',
                              style: AppTypography.body.copyWith(
                                color: const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '100 포인트 = 다음 구매 시 100원 할인',
                              style: AppTypography.small.copyWith(
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard(MissionData mission) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mission.completed
            ? const Color(0xFFF0FDF4)
            : const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18),
        border: mission.completed
            ? Border.all(
                color: const Color(0xFF16A34A).withOpacity(0.2),
                width: 1,
              )
            : null,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          mission.title,
                          style: AppTypography.body.copyWith(
                            color: mission.completed
                                ? const Color(0xFF6B7280)
                                : const Color(0xFF111827),
                            decoration: mission.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (mission.completed) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.check_circle,
                            size: 20,
                            color: Color(0xFF16A34A),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${mission.current}/${mission.total} 완료',
                      style: AppTypography.small.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+${mission.reward}',
                    style: AppTypography.body.copyWith(
                      color: mission.completed
                          ? const Color(0xFF16A34A)
                          : const Color(0xFF2563EB),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '포인트',
                    style: AppTypography.small.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (!mission.completed) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: FigmaPrimaryButton(
                text: '미션 시작',
                variant: ButtonVariant.small,
                onPressed: () {},
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MissionData {
  final int id;
  final String title;
  final int reward;
  final bool completed;
  final int current;
  final int total;

  MissionData({
    required this.id,
    required this.title,
    required this.reward,
    required this.completed,
    required this.current,
    required this.total,
  });
}
