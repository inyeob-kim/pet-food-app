import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../ui/widgets/figma_primary_button.dart';
import '../../../../../ui/widgets/price_delta.dart';
import '../../../../../ui/widgets/card_container.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/router/route_paths.dart';
import '../../../../../core/utils/price_formatter.dart';
import '../../../../../core/widgets/loading.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../../../../../domain/services/onboarding_service.dart';
import '../../../../../features/onboarding/data/repositories/onboarding_repository.dart';
import '../controllers/home_controller.dart';

/// Toss-style 판단 UI Home Screen
/// 실제 API 데이터를 사용하여 Pet 프로필 및 추천 상품 표시
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolledToBottom = false;
  bool _isRecommendationExpanded = false; // 추천 결과 펼침 여부
  bool _hasAutoExpanded = false; // 자동 펼침 여부 (한 번만)

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider.notifier).initialize();
    });
    
    // 스크롤 리스너 추가
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final isAtBottom = currentScroll >= maxScroll - 50; // 50px 여유
    
    if (isAtBottom != _isScrolledToBottom) {
      setState(() {
        _isScrolledToBottom = isAtBottom;
      });
    }
  }

  void _toggleRecommendation() {
    print('[HomeScreen] 🔘 "딱 맞는 사료 보기" 버튼 클릭');
    final state = ref.read(homeControllerProvider);
    final recommendations = state.recommendations;
    final topRecommendation = recommendations?.items.isNotEmpty == true
        ? recommendations!.items[0]
        : null;
    
    print('[HomeScreen] 현재 상태: recommendations=${recommendations?.items.length ?? 0}개, isLoading=${state.isLoadingRecommendations}, expanded=$_isRecommendationExpanded');
    
    // 추천이 없고 로딩 중이 아니면 추천 로드
    if (topRecommendation == null && !state.isLoadingRecommendations) {
      final petSummary = state.petSummary;
      if (petSummary != null) {
        print('[HomeScreen] ✅ 추천 로드 시작: petId=${petSummary.petId}, petName=${petSummary.name}');
        // 추천 로드 시작
        ref.read(homeControllerProvider.notifier).loadRecommendations();
        // 로딩 중이면 펼치지 않음
        return;
      } else {
        print('[HomeScreen] ⚠️ petSummary가 null입니다. 추천을 로드할 수 없습니다.');
      }
    }
    
    // 추천이 있거나 이미 펼쳐진 상태면 토글
    if (topRecommendation != null || _isRecommendationExpanded) {
      print('[HomeScreen] 🔄 추천 결과 토글: ${_isRecommendationExpanded ? "접기" : "펼치기"}');
      setState(() {
        _isRecommendationExpanded = !_isRecommendationExpanded;
      });
      
      // 펼칠 때 스크롤 위치 조정
      if (_isRecommendationExpanded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent * 0.3,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    
    // 추천 로드 완료 감지 (한 번만 자동 펼치기)
    ref.listen<HomeState>(homeControllerProvider, (previous, next) {
      final recommendations = next.recommendations;
      final topRecommendation = recommendations?.items.isNotEmpty == true
          ? recommendations!.items[0]
          : null;
      
      // 추천이 로드 완료되고, 아직 펼치지 않았으면 자동 펼치기
      if (topRecommendation != null && 
          !next.isLoadingRecommendations && 
          !_hasAutoExpanded &&
          !_isRecommendationExpanded) {
        _hasAutoExpanded = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _isRecommendationExpanded = true;
            });
            // 스크롤 위치 조정
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent * 0.3,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          }
        });
      }
    });

    // 로딩 상태
    if (state.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(child: LoadingWidget()),
      );
    }

    // Pet 없음 상태
    if (state.isNoPet) {
      return _buildNoPetState(context);
    }

    // 에러 상태
    if (state.isError) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: EmptyStateWidget(
          title: state.error ?? '오류가 발생했습니다',
          buttonText: '다시 시도',
          onButtonPressed: () => ref.read(homeControllerProvider.notifier).initialize(),
        ),
      );
    }

    // Pet 있음 상태
    final petSummary = state.petSummary;
    final recommendations = state.recommendations;
    final topRecommendation = recommendations?.items.isNotEmpty == true
        ? recommendations!.items[0]
        : null;

    if (petSummary == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: const Center(child: LoadingWidget()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 최소화된 상단 고정 헤더 (정체성만)
            Container(
              color: Colors.white,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FutureBuilder<String?>(
                    future: OnboardingRepositoryImpl().getDraftNickname(),
                    builder: (context, snapshot) {
                      final nickname = snapshot.data ?? '';
                      return Text(
                        nickname.isNotEmpty ? '안녕하세요, $nickname 님' : '안녕하세요',
                        style: AppTypography.body.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            // 건강 리포트 카드
                            _buildHealthReportCard(petSummary),
                            const SizedBox(height: 20),
                            // 히어로 영역 + CTA 버튼 (카드로 묶음)
                            CardContainer(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildHeroSection(petSummary),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: state.isLoadingRecommendations ? null : _toggleRecommendation,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF16A34A),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        elevation: 0,
                                        disabledBackgroundColor: const Color(0xFF16A34A).withOpacity(0.6),
                                      ),
                                      child: state.isLoadingRecommendations
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  '${petSummary.name}에게 딱 맞는 사료 찾는 중...',
                                                  style: AppTypography.button,
                                                ),
                                              ],
                                            )
                                          : Text(
                                              _isRecommendationExpanded && topRecommendation != null
                                                  ? '추천 사료 접기'
                                                  : '딱 맞는 사료 보기',
                                              style: AppTypography.button,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 48),
                          ],
                        ),
                      ),
                      // 추천 결과 영역 (펼침/접기) - 전체 넓이
                      if (_isRecommendationExpanded && topRecommendation != null) ...[
                        _buildRecommendationSection(
                          context,
                          topRecommendation,
                          petSummary,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              // CTA 버튼 (스크롤 중에는 일반 버튼)
                              if (!_isScrolledToBottom)
                                _buildCTAButton(context, topRecommendation),
                              const SizedBox(height: 100), // Space for sticky CTA
                            ],
                          ),
                        ),
                      ] else if (state.isLoadingRecommendations) ...[
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ] else if (topRecommendation == null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildNoRecommendation(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Sticky CTA (스크롤 끝에서만 표시)
      bottomNavigationBar: topRecommendation != null && _isScrolledToBottom
          ? Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 확신 문구
                    Text(
                      '현재 상태를 기준으로 가장 부담 없는 선택이에요',
                      style: AppTypography.small.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // CTA 버튼
                    FigmaPrimaryButton(
                      text: '상세보기',
                      onPressed: () {
                        context.push('/products/${topRecommendation.product.id}');
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }


  /// 히어로 영역 (첫 진입 화면)
  Widget _buildHeroSection(petSummary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 메인 메시지
        Text(
          '오늘, ${petSummary.name}에게',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '딱 맞는 사료',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '🥣',
              style: const TextStyle(
                fontSize: 28,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 추천 결과 전체 섹션
  Widget _buildRecommendationSection(
    BuildContext context,
    recommendationItem,
    petSummary,
  ) {
    final product = recommendationItem.product;
    final avgPrice = recommendationItem.avgPrice;
    final currentPrice = recommendationItem.currentPrice;
    final priceDiff = avgPrice - currentPrice;
    final priceDiffPercent = avgPrice > 0 ? (priceDiff / avgPrice * 100).round() : 0;
    final matchScore = recommendationItem.matchScore.round().toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 추천 사료 요약 블록
        _buildProductSummary(context, product, currentPrice, avgPrice, priceDiffPercent, recommendationItem),
        const SizedBox(height: 16),
        // 적합도 카드 (핵심 카드 1개만)
        _buildMatchScoreCard(petSummary, matchScore, recommendationItem),
        const SizedBox(height: 16),
        // "왜 이 제품?" 설명 섹션
        _buildWhyThisProduct(petSummary, recommendationItem),
      ],
    );
  }


  /// 추천 사료 요약 블록
  Widget _buildProductSummary(
    BuildContext context,
    product,
    int currentPrice,
    int avgPrice,
    int priceDiffPercent,
    recommendationItem,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CardContainer(
        onTap: () => context.push('/products/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // 이미지
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    color: const Color(0xFFF7F8FA),
                    child: const Center(
                      child: Icon(Icons.image, size: 64, color: Color(0xFF6B7280)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 브랜드 + 제품명
          Text(
            product.brandName,
            style: AppTypography.small.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.productName,
            style: AppTypography.h2.copyWith(
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          // 가격 Row: 가격 + 최저가 Chip + 할인 Chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                PriceFormatter.formatWithCurrency(currentPrice),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              // 최저가 Chip
              if (recommendationItem.isNewLow)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '최저가',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              if (recommendationItem.isNewLow && priceDiffPercent > 0)
                const SizedBox(width: 6),
              // 할인 Chip
              if (priceDiffPercent > 0)
                PriceDelta(
                  currentPrice: currentPrice,
                  avgPrice: avgPrice,
                  size: PriceDeltaSize.medium,
                ),
            ],
          ),
          // 평균 대비 텍스트 (가격 Row 바로 아래)
          const SizedBox(height: 8),
          Text(
            '최근 평균 대비 $priceDiffPercent% 저렴해요',
            style: AppTypography.body.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
      ),
    );
  }

  /// "왜 이 제품?" 설명 섹션
  Widget _buildWhyThisProduct(petSummary, recommendationItem) {
    // LLM 생성 설명 우선 사용, 없으면 기술적 이유 표시
    final explanation = recommendationItem.explanation;
    final matchReasons = recommendationItem.matchReasons ?? [];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CardContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '왜 이 제품일까요?',
              style: AppTypography.body.copyWith(
                color: const Color(0xFF111827),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            // LLM 생성 설명이 있으면 표시
            if (explanation != null && explanation.isNotEmpty) ...[
              Text(
                explanation,
                style: AppTypography.body.copyWith(
                  color: const Color(0xFF111827),
                  height: 1.5,
                ),
              ),
            ] else if (matchReasons.isNotEmpty) ...[
              // 기술적 이유를 애니메이션과 함께 bullet point로 표시
              ...matchReasons.asMap().entries.map((entry) {
                final index = entry.key as int;
                final reason = entry.value;
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  curve: Curves.easeOut,
                  builder: (context, opacity, child) {
                    return Opacity(
                      opacity: opacity,
                      child: Transform.translate(
                        offset: Offset(0, 10 * (1 - opacity)),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildAnimatedBulletPoint(reason),
                        ),
                      ),
                    );
                  },
                );
              }),
            ] else ...[
              // Fallback 설명
              _buildAnimatedBulletPoint('${petSummary.weightKg.toStringAsFixed(1)}kg 체중에 적합'),
              const SizedBox(height: 8),
              _buildAnimatedBulletPoint('${petSummary.ageStage ?? '성견'} 단계에 맞는 사료'),
              if (petSummary.healthConcerns.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildAnimatedBulletPoint('건강 고민을 고려한 사료'),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNoRecommendation() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off,
            size: 48,
            color: Color(0xFF6B7280),
          ),
          const SizedBox(height: 16),
          Text(
            '추천 상품이 없습니다',
            style: AppTypography.body.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '마켓에서 사료를 둘러보세요',
            style: AppTypography.small.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  /// Pet 없음 상태 UI (온보딩 완료 여부에 따라 다른 메시지 표시)
  Widget _buildNoPetState(BuildContext context) {
    return FutureBuilder<bool>(
      future: ref.read(onboardingServiceProvider).isOnboardingCompleted(),
      builder: (context, snapshot) {
        final isOnboardingCompleted = snapshot.data ?? false;
        
        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 아이콘
                  Icon(
                    Icons.pets_outlined,
                    size: 64,
                    color: AppColors.iconMuted,
                  ),
                  const SizedBox(height: 24),
                  // 제목
                  Text(
                    isOnboardingCompleted
                        ? '프로필을 불러올 수 없습니다'
                        : '프로필을 만들어주세요',
                    style: AppTypography.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  // 설명
                  const SizedBox(height: 8),
                  Text(
                    isOnboardingCompleted
                        ? '프로필 정보를 다시 불러오는 중입니다'
                        : '반려동물 정보를 입력하면 맞춤 추천을 받을 수 있어요',
                    style: AppTypography.body2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // 프로필 다시 불러오기 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isOnboardingCompleted) {
                          // 프로필 다시 불러오기
                          ref.read(homeControllerProvider.notifier).initialize();
                        } else {
                          // 프로필 만들기 (온보딩으로 이동)
                          context.go(RoutePaths.onboarding);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isOnboardingCompleted
                            ? '프로필 다시 불러오기'
                            : '프로필 만들기',
                        style: AppTypography.button,
                      ),
                    ),
                  ),
                  // 다시 회원가입 하기 버튼 (임시)
                  if (isOnboardingCompleted) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () async {
                          // 온보딩 완료 상태 초기화
                          final repository = OnboardingRepositoryImpl();
                          await repository.clearAll();
                          // 온보딩 화면으로 이동
                          if (context.mounted) {
                            context.go(RoutePaths.onboarding);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: BorderSide(
                            color: AppColors.divider,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: Text(
                          '다시 회원가입 하기',
                          style: AppTypography.button.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 적합도 카드 (스크롤 유도 앵커)
  Widget _buildMatchScoreCard(petSummary, int matchScore, recommendationItem) {
    final matchReasons = (recommendationItem.matchReasons ?? []) as List<String>;
    // matchReasons에서 주요 이유 2-3개 추출 (긴 설명은 제외)
    final shortReasons = matchReasons
        .where((String reason) => reason.length < 30)
        .take(3)
        .toList();
    final summaryText = shortReasons.isNotEmpty
        ? shortReasons.join(' · ')
        : '${petSummary.name}에게 적합한 사료';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: matchScore / 100.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return CardContainer(
            padding: const EdgeInsets.all(24),
            backgroundColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단: 체크 아이콘 + 점수 (애니메이션)
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 24,
                      color: Color(0xFF16A34A),
                    ),
                    const SizedBox(width: 8),
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: matchScore),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      builder: (context, animatedScore, child) {
                        return Text(
                          '$animatedScore%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                            letterSpacing: -0.5,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 하단: "{petName}에게 잘 맞을 확률이에요"
                Text(
                  '${petSummary.name}에게 잘 맞을 확률이에요',
                  style: AppTypography.body.copyWith(
                    color: const Color(0xFF111827),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // 설명: matchReasons 기반
                Text(
                  summaryText,
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// CTA 버튼 (스크롤 중 일반 버튼)
  Widget _buildCTAButton(BuildContext context, recommendationItem) {
    return Column(
      children: [
        Text(
          '현재 상태를 기준으로 가장 부담 없는 선택이에요',
          style: AppTypography.small.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FigmaPrimaryButton(
            text: '상세보기',
            onPressed: () {
              context.push('/products/${recommendationItem.product.id}');
            },
          ),
        ),
      ],
    );
  }

  /// 건강 리포트 카드
  Widget _buildHealthReportCard(petSummary) {
    return CardContainer(
      padding: const EdgeInsets.all(20),
      backgroundColor: const Color(0xFFF0FDF4),
      showBorder: true,
      onTap: () {
        context.push(RoutePaths.petProfileDetail, extra: petSummary);
      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF16A34A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${petSummary.name}의 건강 리포트',
                  style: AppTypography.small.copyWith(
                    color: const Color(0xFF111827),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFF6B7280),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                petSummary.species == 'DOG' ? '🐕' : '🐈',
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${petSummary.species == 'DOG' ? '강아지' : '고양이'}, ${petSummary.ageStage == 'PUPPY' ? '강아지' : petSummary.ageStage == 'ADULT' ? '성견' : petSummary.ageStage == 'SENIOR' ? '노견' : '성견'}',
                      style: AppTypography.body.copyWith(
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '체중 ${petSummary.weightKg.toStringAsFixed(1)}kg',
                      style: AppTypography.small.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '건강 상태',
                      style: AppTypography.small.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      petSummary.healthConcerns.isEmpty ? '양호' : '주의',
                      style: AppTypography.small.copyWith(
                        color: petSummary.healthConcerns.isEmpty
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFF59E0B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: petSummary.healthConcerns.isEmpty ? 0.85 : 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: petSummary.healthConcerns.isEmpty
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 애니메이션 불릿 포인트 위젯 (개선된 버전)
  Widget _buildAnimatedBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6, right: 12),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFF16A34A), // 초록색
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF16A34A).withOpacity(0.3),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTypography.body.copyWith(
              color: const Color(0xFF111827),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
