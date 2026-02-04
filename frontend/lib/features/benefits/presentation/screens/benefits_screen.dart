import 'package:flutter/material.dart';
import '../../../../../ui/widgets/app_scaffold.dart';
import '../../../../../ui/theme/app_colors.dart';
import '../../../../../ui/theme/app_typography.dart';
import '../../../../../ui/components/section_header.dart';

/// 혜택 화면 (토스 스타일 - 정돈된 리워드)
class BenefitsScreen extends StatelessWidget {
  const BenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시 미션 데이터 (나중에 컨트롤러로 이동)
    final missions = [
      _MissionData(
        id: '1',
        title: '알림 설정하기',
        description: '가격 변동 알림을 받아보세요',
        points: 100,
        icon: Icons.notifications_outlined,
        isCompleted: false,
        onTap: () {
          // TODO: 알림 설정 화면으로 이동
        },
      ),
      _MissionData(
        id: '2',
        title: '첫 추천 확인하기',
        description: '맞춤 추천 사료를 확인해보세요',
        points: 50,
        icon: Icons.recommend_outlined,
        isCompleted: false,
        onTap: () {
          // TODO: 홈 화면으로 이동
        },
      ),
      _MissionData(
        id: '3',
        title: '프로필 완성하기',
        description: '반려동물 정보를 입력하세요',
        points: 200,
        icon: Icons.pets_outlined,
        isCompleted: false,
        onTap: () {
          // TODO: 프로필 화면으로 이동
        },
      ),
    ];

    return AppScaffold(
      appBar: AppBar(
        title: Text('혜택', style: AppTypography.title),
        elevation: 0,
        backgroundColor: AppColors.bg,
        surfaceTintColor: AppColors.bg,
      ),
      backgroundColor: AppColors.bg,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          // 상단 Hero 포인트 영역 (카드 없이)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('내 포인트', style: AppTypography.title),
                const SizedBox(height: 12),
                // Hero 스타일 포인트
                Text(
                  '0 P',
                  style: AppTypography.heroNumber,
                ),
                const SizedBox(height: 8),
                // 보조 문장 sub
                Text(
                  '미션을 완료하면 포인트가 쌓여요',
                  style: AppTypography.sub,
                ),
              ],
            ),
          ),

          // 미션 섹션 헤더
          const SectionHeader(
            title: '미션',
            subtitle: '완료하면 포인트를 받을 수 있어요',
          ),

          // 미션 리스트 (ListTile 스타일)
          ...missions.map((mission) => _MissionTile(mission: mission)),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// 미션 데이터 모델
class _MissionData {
  final String id;
  final String title;
  final String description;
  final int points;
  final IconData icon;
  final bool isCompleted;
  final VoidCallback onTap;

  _MissionData({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
    this.isCompleted = false,
    required this.onTap,
  });
}

/// 미션 리스트 타일 (ListTile 스타일)
class _MissionTile extends StatelessWidget {
  final _MissionData mission;

  const _MissionTile({required this.mission});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // 좌측: 아이콘(작게)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              mission.icon,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          
          // 가운데: 미션명 / 보조설명
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        mission.title,
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (mission.isCompleted) ...[
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.positive,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.positive.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '완료',
                          style: AppTypography.sub.copyWith(
                            fontSize: 11,
                            color: AppColors.positive,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  mission.description,
                  style: AppTypography.sub,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          
          // 우측: CTA 버튼(작게, radius 12~14)
          if (!mission.isCompleted)
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: mission.onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13), // 12~14 범위
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '${mission.points}P 받기',
                  style: AppTypography.sub.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: AppColors.divider,
                  width: 1,
                ),
              ),
              child: Text(
                '완료됨',
                style: AppTypography.sub.copyWith(
                  color: AppColors.textSub,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
