import 'package:flutter/material.dart';
import '../../../../../ui/widgets/figma_app_bar.dart';
import '../../../../../data/mock/figma_mock_data.dart';
import '../../../../../app/theme/app_typography.dart';

/// Figma 디자인 기반 My Screen
class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final petData = FigmaMockData.petData;
    final settings = [
      SettingData(
        icon: Icons.notifications,
        label: '알림',
        value: '켜짐',
        hasToggle: true,
      ),
      SettingData(
        icon: Icons.lock,
        label: '개인정보',
        hasChevron: true,
      ),
      SettingData(
        icon: Icons.help_outline,
        label: '도움말 및 지원',
        hasChevron: true,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const FigmaAppBar(title: '마이'),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Health Summary Pill
                      _buildHealthSummary(petData),
                      const SizedBox(height: 32),
                      // Profile Info List
                      Text(
                        '프로필 정보',
                        style: AppTypography.body.copyWith(
                          color: const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoItem('체중', '${petData['weight']}kg'),
                      const SizedBox(height: 12),
                      _buildInfoItem('나이', '${petData['age']}살'),
                      const SizedBox(height: 12),
                      _buildInfoItem('품종', petData['breed'] as String),
                      const SizedBox(height: 32),
                      // Notification Settings
                      Text(
                        '설정',
                        style: AppTypography.body.copyWith(
                          color: const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...settings.map((setting) => _buildSettingItem(setting)),
                      const SizedBox(height: 32),
                      // Point Summary Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFEFF6FF),
                              Color(0xFFF7F8FA),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '사용 가능한 포인트',
                                  style: AppTypography.body.copyWith(
                                    color: const Color(0xFF111827),
                                  ),
                                ),
                                Text(
                                  '1,850',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '포인트를 사용하여 다음 구매 시 할인받기',
                              style: AppTypography.small.copyWith(
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 36,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  '혜택 보기',
                                  style: AppTypography.small.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Logout
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.logout,
                                  size: 20,
                                  color: Color(0xFFEF4444),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '로그아웃',
                                  style: AppTypography.body.copyWith(
                                    color: const Color(0xFFEF4444),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSummary(Map<String, dynamic> petData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF16A34A).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '🐕',
                style: TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      petData['name'] as String,
                      style: AppTypography.body.copyWith(
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${petData['breed']}, ${petData['age']}살',
                      style: AppTypography.small.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'BCS ${petData['bcs']}',
                    style: AppTypography.body.copyWith(
                      color: const Color(0xFF16A34A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '건강함',
                style: AppTypography.small.copyWith(
                  color: const Color(0xFF16A34A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
          Text(
            value,
            style: AppTypography.body.copyWith(
              color: const Color(0xFF111827),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(SettingData setting) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                setting.icon,
                size: 20,
                color: const Color(0xFF6B7280),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  setting.label,
                  style: AppTypography.body.copyWith(
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              if (setting.value != null) ...[
                Text(
                  setting.value!,
                  style: AppTypography.body.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (setting.hasToggle)
                Container(
                  width: 44,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                )
              else if (setting.hasChevron)
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Color(0xFF6B7280),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingData {
  final IconData icon;
  final String label;
  final String? value;
  final bool hasToggle;
  final bool hasChevron;

  SettingData({
    required this.icon,
    required this.label,
    this.value,
    this.hasToggle = false,
    this.hasChevron = false,
  });
}
