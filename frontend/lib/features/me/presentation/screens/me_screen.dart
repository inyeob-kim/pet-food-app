import 'package:flutter/material.dart';
import '../../../../ui/widgets/app_scaffold.dart';
import '../../../../ui/widgets/app_header.dart';
import '../../../../ui/widgets/card_container.dart';
import '../../../../ui/theme/app_typography.dart';
import '../../../../ui/theme/app_spacing.dart';

/// 마이 화면
class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppHeader(
        title: '마이',
        showNotification: false,
      ),
      body: ListView(
        children: [
          // 반려견 프로필 섹션
          CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('반려동물 프로필', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.sectionGap),
                _ProfileItem(label: '견종', value: '골든 리트리버'),
                const SizedBox(height: AppSpacing.sectionGap),
                _ProfileItem(label: '체중', value: '10-15kg'),
                const SizedBox(height: AppSpacing.sectionGap),
                _ProfileItem(label: '나이', value: '성견'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          
          // 알림 설정 섹션
          CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('알림 설정', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.sectionGap),
                _SettingItem(
                  title: '가격 알림',
                  subtitle: '최저가 알림 받기',
                  value: true,
                  onChanged: (value) {
                    // TODO: 알림 설정 업데이트
                  },
                ),
                const Divider(height: 1),
                _SettingItem(
                  title: '푸시 알림',
                  subtitle: '앱 푸시 알림 받기',
                  value: true,
                  onChanged: (value) {
                    // TODO: 알림 설정 업데이트
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          
          // 포인트 섹션
          CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('포인트', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.sectionGap),
                Text('0 P', style: AppTypography.titleLarge),
                const SizedBox(height: 4),
                Text(
                  '사료 구매 시 포인트를 적립할 수 있습니다',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: AppTypography.caption),
        ),
        Text(value, style: AppTypography.body),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.body),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTypography.caption),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
