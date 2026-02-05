import 'package:flutter/material.dart';
import '../onboarding_shell.dart';
import '../../ui/widgets/figma_search_bar.dart';
import '../../app/theme/app_typography.dart';

/// Step 5: Breed (Dog only) - matches React Step5Breed
class Step05Breed extends StatefulWidget {
  final String value;
  final ValueChanged<String> onUpdate;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const Step05Breed({
    super.key,
    required this.value,
    required this.onUpdate,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  State<Step05Breed> createState() => _Step05BreedState();
}

class _Step05BreedState extends State<Step05Breed> {
  late TextEditingController _searchController;

  // 대표적인 강아지 품종 목록
  final List<String> _popularBreeds = [
    '골든리트리버',
    '래브라도리트리버',
    '비글',
    '불독',
    '푸들',
    '치와와',
    '요크셔테리어',
    '시추',
    '포메라니안',
    '말티즈',
    '비숑프리제',
    '웰시코기',
    '허스키',
    '진돗개',
    '믹스',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get isValid => _searchController.text.trim().isNotEmpty;

  void _onSearchChanged(String value) {
    widget.onUpdate(value);
    setState(() {}); // isValid 업데이트를 위해
  }

  void _onBreedTagTap(String breed) {
    _searchController.text = breed;
    widget.onUpdate(breed);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: widget.currentStep,
      totalSteps: widget.totalSteps,
      onBack: widget.onBack,
      emoji: '🐶',
      title: '어떤 품종인가요? 🐶',
      ctaText: '다음',
      ctaDisabled: !isValid,
      onCTAClick: widget.onNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '품종',
            style: AppTypography.small.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          FigmaSearchBar(
            controller: _searchController,
            placeholder: '품종을 검색하세요',
            onSearch: _onSearchChanged,
          ),
          const SizedBox(height: 24),
          Text(
            '대표 품종',
            style: AppTypography.small.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.start,
            children: _popularBreeds.map((breed) {
              final isSelected = _searchController.text.trim() == breed;
              return _CompactBreedChip(
                label: breed,
                selected: isSelected,
                onTap: () => _onBreedTagTap(breed),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// 컴팩트한 품종 태그 위젯
class _CompactBreedChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CompactBreedChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 32,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF2563EB)
                : const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: AppTypography.small.copyWith(
              fontSize: 13,
              color: selected
                  ? Colors.white
                  : const Color(0xFF111827),
            ),
          ),
        ),
      ),
    );
  }
}
