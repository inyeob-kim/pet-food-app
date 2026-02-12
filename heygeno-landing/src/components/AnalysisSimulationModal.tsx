import { useState, useEffect } from 'react';
import { X, Loader2, AlertCircle, CheckCircle, Shield, Award, XCircle, Info, ArrowRight } from 'lucide-react';
import productImage from 'figma:asset/1f513950e90391a568bd6fbe59d74c33c122cf66.png';

interface AnalysisSimulationModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export function AnalysisSimulationModal({ isOpen, onClose }: AnalysisSimulationModalProps) {
  const [currentStep, setCurrentStep] = useState(0);
  const [ingredientCount, setIngredientCount] = useState(0);
  const [isTransitioning, setIsTransitioning] = useState(false);

  const goToStep = (step: number) => {
    setIsTransitioning(true);
    setTimeout(() => {
      setCurrentStep(step);
      setIsTransitioning(false);
    }, 300);
  };

  useEffect(() => {
    if (!isOpen) {
      setCurrentStep(0);
      setIngredientCount(0);
      return;
    }

    // 초기화
    setCurrentStep(0);
    setIngredientCount(0);

    // Auto-advance through steps
    const stepTimers = [
      setTimeout(() => goToStep(1), 2000),  // Step 1: 2s
      setTimeout(() => goToStep(2), 4500),  // Step 2: 4.5s
      setTimeout(() => goToStep(3), 7000),  // Step 3: 7s
      setTimeout(() => goToStep(4), 9500),  // Step 4: 9.5s
      setTimeout(() => goToStep(5), 12000), // Step 5: 12s
    ];

    return () => {
      stepTimers.forEach(timer => clearTimeout(timer));
    };
  }, [isOpen]);

  // Ingredient count animation for step 1
  useEffect(() => {
    if (currentStep !== 1) return;

    let count = 0;
    const countInterval = setInterval(() => {
      count += 2;
      if (count >= 36) {
        count = 36;
        clearInterval(countInterval);
      }
      setIngredientCount(count);
    }, 40);

    return () => clearInterval(countInterval);
  }, [currentStep]);

  if (!isOpen) return null;

  console.log('✅ AnalysisSimulationModal RENDERING - currentStep:', currentStep);

  const totalSteps = 6;
  const progress = ((currentStep + 1) / totalSteps) * 100;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm" onClick={onClose}>
      <div 
        className="bg-white rounded-2xl sm:rounded-3xl shadow-2xl max-w-lg sm:max-w-xl w-full mx-4 h-[90vh] sm:h-[85vh] flex flex-col relative overflow-hidden"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Close Button */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 sm:top-6 sm:right-6 w-9 h-9 sm:w-10 sm:h-10 rounded-full bg-white/90 hover:bg-white shadow-lg transition-colors flex items-center justify-center z-50"
        >
          <X className="w-4 h-4 sm:w-5 sm:h-5" style={{ color: '#475569' }} />
        </button>

        {/* Progress Bar */}
        <div className="absolute top-0 left-0 right-0 h-1 sm:h-1.5 bg-gray-200 z-40">
          <div 
            className="h-full transition-all duration-500 ease-out"
            style={{ 
              width: `${progress}%`,
              backgroundColor: '#2563EB'
            }}
          />
        </div>

        {/* Step Indicator */}
        <div className="absolute top-14 sm:top-16 left-1/2 -translate-x-1/2 z-40 px-4 py-2 rounded-full bg-white/90 backdrop-blur-sm shadow-lg">
          <div className="flex items-center gap-2">
            {[0, 1, 2, 3, 4, 5].map((step) => (
              <div
                key={step}
                className={`w-1.5 h-1.5 sm:w-2 sm:h-2 rounded-full transition-all duration-300 ${
                  step === currentStep 
                    ? 'w-6 sm:w-8' 
                    : ''
                }`}
                style={{ 
                  backgroundColor: step <= currentStep ? '#2563EB' : '#E5E7EB'
                }}
              />
            ))}
          </div>
        </div>

        {/* Content Container */}
        <div className="flex-1 relative overflow-hidden">
          <div
            className={`absolute inset-0 transition-all duration-500 ease-in-out ${
              isTransitioning ? 'opacity-0 scale-95' : 'opacity-100 scale-100'
            }`}
          >
            {/* Step 0: 시작 화면 */}
            {currentStep === 0 && (
              <div className="h-full flex flex-col items-center justify-center p-4 sm:p-8 text-center">
                <div className="w-14 h-14 sm:w-20 sm:h-20 rounded-full flex items-center justify-center mb-4 sm:mb-6 animate-pulse" style={{ backgroundColor: '#EFF6FF' }}>
                  <Loader2 className="w-7 h-7 sm:w-10 sm:h-10 animate-spin" style={{ color: '#2563EB' }} />
                </div>
                
                <h2 className="text-xl sm:text-3xl font-bold mb-3 sm:mb-4" style={{ color: '#0F172A' }}>
                  제노에게 맞는 사료 분석 중
                </h2>
                <p className="text-sm sm:text-lg mb-6 sm:mb-8" style={{ color: '#475569' }}>
                  말티즈, 3세 · 3.2kg
                </p>

                <div className="bg-gradient-to-br from-gray-50 to-gray-100 rounded-xl sm:rounded-2xl p-3 sm:p-6 mb-6 sm:mb-8 max-w-md w-full">
                  <div className="flex items-center gap-3 sm:gap-4">
                    <div className="w-16 h-16 sm:w-24 sm:h-24 rounded-lg sm:rounded-xl overflow-hidden shadow-md bg-white flex-shrink-0">
                      <img
                        src={productImage}
                        alt="사료"
                        className="w-full h-full object-contain"
                      />
                    </div>
                    <div className="flex-1 text-left">
                      <h3 className="text-sm sm:text-lg font-bold mb-1" style={{ color: '#0F172A' }}>
                        헤이제노 강아지 사료
                      </h3>
                      <p className="text-xs sm:text-sm" style={{ color: '#475569' }}>
                        소형견 성견용 · 2kg
                      </p>
                    </div>
                  </div>
                </div>

                <div className="flex items-center gap-2 text-xs sm:text-sm" style={{ color: '#475569' }}>
                  <Loader2 className="w-3 h-3 sm:w-4 sm:h-4 animate-spin" style={{ color: '#2563EB' }} />
                  <span>분석을 시작합니다...</span>
                </div>
              </div>
            )}

            {/* Step 1: 성분 스캔 */}
            {currentStep === 1 && (
              <div className="h-full flex flex-col items-center justify-center p-4 sm:p-8">
                <div className="w-14 h-14 sm:w-20 sm:h-20 rounded-full flex items-center justify-center mb-4 sm:mb-6" style={{ backgroundColor: '#EFF6FF' }}>
                  <CheckCircle className="w-7 h-7 sm:w-10 sm:h-10" style={{ color: '#14B8A6' }} />
                </div>
                
                <h2 className="text-xl sm:text-3xl font-bold mb-3 sm:mb-4 text-center" style={{ color: '#0F172A' }}>
                  성분 스캔 완료
                </h2>
                <p className="text-sm sm:text-lg mb-6 sm:mb-8 text-center" style={{ color: '#475569' }}>
                  총 {ingredientCount}개의 원재료 검출
                </p>

                <div className="w-full max-w-md space-y-3 sm:space-y-4 px-2">
                  <div className="bg-gradient-to-br from-blue-50 to-teal-50 rounded-xl sm:rounded-2xl p-5 sm:p-6 text-center">
                    <div className="text-4xl sm:text-6xl font-bold mb-2" style={{ color: '#2563EB' }}>
                      {ingredientCount}
                    </div>
                    <div className="text-sm sm:text-base font-semibold" style={{ color: '#475569' }}>
                      검출된 성분
                    </div>
                  </div>

                  <div className="bg-white rounded-lg sm:rounded-xl p-4 sm:p-5 border-2" style={{ borderColor: '#E5E7EB' }}>
                    <div className="text-xs sm:text-sm font-semibold mb-2 sm:mb-3" style={{ color: '#0F172A' }}>
                      주요 성분
                    </div>
                    <div className="flex flex-wrap gap-2">
                      {['닭고기', '쌀', '옥수수', '비트펄프', '닭지방', '밀'].map((ing) => (
                        <span key={ing} className="px-2.5 sm:px-3 py-1 sm:py-1.5 rounded-full text-xs font-medium bg-gray-100" style={{ color: '#475569' }}>
                          {ing}
                        </span>
                      ))}
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* Step 2: 알레르기 검사 */}
            {currentStep === 2 && (
              <div className="h-full flex flex-col items-center justify-center p-4 sm:p-8">
                <div className="w-14 h-14 sm:w-20 sm:h-20 rounded-full flex items-center justify-center mb-4 sm:mb-6" style={{ backgroundColor: '#ECFDF5' }}>
                  <CheckCircle className="w-7 h-7 sm:w-10 sm:h-10" style={{ color: '#14B8A6' }} />
                </div>
                
                <h2 className="text-xl sm:text-3xl font-bold mb-3 sm:mb-4 text-center" style={{ color: '#0F172A' }}>
                  알레르기 검사 통과
                </h2>
                <p className="text-sm sm:text-lg mb-6 sm:mb-8 text-center" style={{ color: '#475569' }}>
                  제노에게 안전한 성분으로 구성되어 있습니다
                </p>

                <div className="w-full max-w-md space-y-3 sm:space-y-4 px-2">
                  <div className="bg-gradient-to-br from-emerald-50 to-teal-50 rounded-xl sm:rounded-2xl p-5 sm:p-6">
                    <div className="flex items-center justify-center gap-2 sm:gap-3 mb-5 sm:mb-6">
                      <div className="text-4xl sm:text-6xl font-bold" style={{ color: '#14B8A6' }}>
                        0
                      </div>
                      <div className="text-left">
                        <div className="text-xs sm:text-sm font-semibold" style={{ color: '#14B8A6' }}>
                          알레르기 성분
                        </div>
                        <div className="text-xs" style={{ color: '#475569' }}>
                          검출되지 않음
                        </div>
                      </div>
                    </div>

                    <div className="space-y-2 sm:space-y-3">
                      <div className="bg-white rounded-lg sm:rounded-xl p-3 sm:p-4 flex items-start gap-2 sm:gap-3">
                        <CheckCircle className="w-4 h-4 sm:w-5 sm:h-5 flex-shrink-0 mt-0.5" style={{ color: '#14B8A6' }} />
                        <div>
                          <div className="font-semibold text-xs sm:text-sm mb-0.5 sm:mb-1" style={{ color: '#0F172A' }}>닭고기 단백질</div>
                          <div className="text-xs" style={{ color: '#475569' }}>제노에게 안전한 주성분</div>
                        </div>
                      </div>
                      <div className="bg-white rounded-lg sm:rounded-xl p-3 sm:p-4 flex items-start gap-2 sm:gap-3">
                        <CheckCircle className="w-4 h-4 sm:w-5 sm:h-5 flex-shrink-0 mt-0.5" style={{ color: '#14B8A6' }} />
                        <div>
                          <div className="font-semibold text-xs sm:text-sm mb-0.5 sm:mb-1" style={{ color: '#0F172A' }}>현미 & 귀리</div>
                          <div className="text-xs" style={{ color: '#475569' }}>소화가 잘 되는 곡물</div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* Step 3: 유해 성분 분석 */}
            {currentStep === 3 && (
              <div className="h-full flex flex-col items-center justify-center p-4 sm:p-8">
                <div className="w-14 h-14 sm:w-20 sm:h-20 rounded-full flex items-center justify-center mb-4 sm:mb-6" style={{ backgroundColor: '#FFF7ED' }}>
                  <Info className="w-7 h-7 sm:w-10 sm:h-10" style={{ color: '#F97316' }} />
                </div>
                
                <h2 className="text-xl sm:text-3xl font-bold mb-3 sm:mb-4 text-center" style={{ color: '#0F172A' }}>
                  주의 성분 검출
                </h2>
                <p className="text-sm sm:text-lg mb-6 sm:mb-8 text-center" style={{ color: '#475569' }}>
                  보존제 및 첨가물 분석 결과
                </p>

                <div className="w-full max-w-md px-2">
                  <div className="bg-gradient-to-br from-orange-50 to-yellow-50 rounded-xl sm:rounded-2xl p-4 sm:p-6">
                    <div className="bg-white rounded-lg sm:rounded-xl p-4 sm:p-5">
                      <div className="flex items-start gap-2 sm:gap-3">
                        <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-full flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#FFF7ED' }}>
                          <AlertCircle className="w-4 h-4 sm:w-5 sm:h-5" style={{ color: '#F97316' }} />
                        </div>
                        <div className="flex-1">
                          <div className="font-bold text-sm sm:text-base mb-1 sm:mb-2" style={{ color: '#0F172A' }}>
                            BHA (부틸화 하이드록시아니솔)
                          </div>
                          <div className="text-xs sm:text-sm leading-relaxed" style={{ color: '#475569' }}>
                            장기 섭취 시 주의가 필요한 합성 보존제입니다
                          </div>
                          <div className="mt-3 sm:mt-4 px-2.5 sm:px-3 py-1.5 sm:py-2 rounded-lg inline-block text-xs font-semibold" style={{ backgroundColor: '#FFF7ED', color: '#F97316' }}>
                            ⚠️ 장기 섭취 주의
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* Step 4: 품질 평가 */}
            {currentStep === 4 && (
              <div className="h-full flex flex-col items-center justify-center p-4 sm:p-8">
                <div className="w-14 h-14 sm:w-20 sm:h-20 rounded-full flex items-center justify-center mb-4 sm:mb-6" style={{ backgroundColor: '#EFF6FF' }}>
                  <Shield className="w-7 h-7 sm:w-10 sm:h-10" style={{ color: '#2563EB' }} />
                </div>
                
                <h2 className="text-xl sm:text-3xl font-bold mb-3 sm:mb-4 text-center" style={{ color: '#0F172A' }}>
                  품질 평가 완료
                </h2>
                <p className="text-sm sm:text-lg mb-6 sm:mb-8 text-center" style={{ color: '#475569' }}>
                  영양 균형 및 품질 분석
                </p>

                <div className="w-full max-w-md px-2">
                  <div className="bg-gradient-to-br from-blue-50 to-teal-50 rounded-xl sm:rounded-2xl p-4 sm:p-6">
                    <div className="space-y-2 sm:space-y-3">
                      <div className="bg-white rounded-lg sm:rounded-xl p-3 sm:p-4 flex items-start gap-2 sm:gap-3">
                        <CheckCircle className="w-4 h-4 sm:w-5 sm:h-5 flex-shrink-0 mt-0.5" style={{ color: '#14B8A6' }} />
                        <div>
                          <div className="font-semibold text-xs sm:text-sm" style={{ color: '#0F172A' }}>
                            첫 성분: 동물성 단백질 (닭고기)
                          </div>
                        </div>
                      </div>
                      <div className="bg-white rounded-lg sm:rounded-xl p-3 sm:p-4 flex items-start gap-2 sm:gap-3">
                        <CheckCircle className="w-4 h-4 sm:w-5 sm:h-5 flex-shrink-0 mt-0.5" style={{ color: '#14B8A6' }} />
                        <div>
                          <div className="font-semibold text-xs sm:text-sm" style={{ color: '#0F172A' }}>
                            단백질 함량: 적정 수준
                          </div>
                        </div>
                      </div>
                      <div className="bg-white rounded-lg sm:rounded-xl p-3 sm:p-4 flex items-start gap-2 sm:gap-3">
                        <CheckCircle className="w-4 h-4 sm:w-5 sm:h-5 flex-shrink-0 mt-0.5" style={{ color: '#14B8A6' }} />
                        <div>
                          <div className="font-semibold text-xs sm:text-sm" style={{ color: '#0F172A' }}>
                            하루 권장 급여량: 약 68g
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* Step 5: 종합 판정 */}
            {currentStep === 5 && (
              <div className="h-full flex flex-col overflow-y-auto pt-14 sm:pt-20">
                <div className="flex-1 flex flex-col items-center justify-center p-3 sm:p-8">
                  <div className="w-full max-w-md">
                    {/* 점수 카드 */}
                    <div className="bg-gradient-to-br from-blue-500 to-teal-500 rounded-xl sm:rounded-2xl p-5 sm:p-8 text-white text-center mb-4 sm:mb-6">
                      <div className="flex items-center justify-center gap-3 sm:gap-4 mb-4 sm:mb-6">
                        <Award className="w-8 h-8 sm:w-12 sm:h-12" />
                        <div className="text-left">
                          <h3 className="text-lg sm:text-2xl font-bold">종합 판정</h3>
                          <p className="text-xs sm:text-sm opacity-90">AI 기반 맞춤 분석</p>
                        </div>
                      </div>
                      
                      <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 sm:p-6">
                        <div className="text-5xl sm:text-7xl font-bold mb-1 sm:mb-2">85점</div>
                        <div className="text-sm sm:text-lg font-semibold mb-3 sm:mb-4">100점 만점</div>
                        <div className="inline-block px-4 sm:px-6 py-1.5 sm:py-2 rounded-full text-xs sm:text-sm font-bold bg-white/20">
                          ✅ 제노에게 적합합니다
                        </div>
                      </div>
                    </div>

                    {/* 긍정적인 포인트 */}
                    <div className="bg-gradient-to-br from-blue-50 to-teal-50 rounded-xl sm:rounded-2xl p-4 sm:p-6 mb-4 sm:mb-6">
                      <div className="font-bold text-base sm:text-lg mb-3 sm:mb-4" style={{ color: '#0F172A' }}>
                        제노에게 좋은 이유
                      </div>
                      <div className="space-y-2 sm:space-y-3">
                        <div className="flex items-start gap-2 sm:gap-3 p-3 sm:p-4 bg-white rounded-lg sm:rounded-xl">
                          <div className="w-5 h-5 sm:w-6 sm:h-6 rounded-full flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#DBEAFE' }}>
                            <span className="text-xs font-bold" style={{ color: '#2563EB' }}>1</span>
                          </div>
                          <p className="text-xs sm:text-sm" style={{ color: '#475569' }}>
                            알레르기 성분이 <strong>전혀 없어</strong> 안전합니다
                          </p>
                        </div>
                        <div className="flex items-start gap-2 sm:gap-3 p-3 sm:p-4 bg-white rounded-lg sm:rounded-xl">
                          <div className="w-5 h-5 sm:w-6 sm:h-6 rounded-full flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#DBEAFE' }}>
                            <span className="text-xs font-bold" style={{ color: '#2563EB' }}>2</span>
                          </div>
                          <p className="text-xs sm:text-sm" style={{ color: '#475569' }}>
                            <strong>동물성 단백질</strong>이 주성분으로 영양이 풍부합니다
                          </p>
                        </div>
                        <div className="flex items-start gap-2 sm:gap-3 p-3 sm:p-4 bg-white rounded-lg sm:rounded-xl">
                          <div className="w-5 h-5 sm:w-6 sm:h-6 rounded-full flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#DBEAFE' }}>
                            <span className="text-xs font-bold" style={{ color: '#2563EB' }}>3</span>
                          </div>
                          <p className="text-xs sm:text-sm" style={{ color: '#475569' }}>
                            소형견 성견에 <strong>최적화된 영양 밸런스</strong>
                          </p>
                        </div>
                      </div>
                    </div>

                    {/* CTA */}
                    <a
                      href="https://forms.gle/sniAUJaSQktvAjzH6"
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center justify-center gap-2 w-full py-3 sm:py-4 rounded-lg sm:rounded-xl text-white font-semibold text-center shadow-lg hover:shadow-xl transition-all text-sm sm:text-lg group"
                      style={{ backgroundColor: '#2563EB' }}
                    >
                      더 많은 사료 석 받아보기
                      <ArrowRight className="w-4 h-4 sm:w-5 sm:h-5 group-hover:translate-x-1 transition-transform" />
                    </a>
                    <p className="text-xs text-center mt-2 sm:mt-3" style={{ color: '#94A3B8' }}>
                      사전 등록 시 1,000P 리워드 제공
                    </p>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>

      <style>{`
        @keyframes slide-in {
          from { 
            opacity: 0; 
            transform: translateX(30px);
          }
          to { 
            opacity: 1; 
            transform: translateX(0);
          }
        }
      `}</style>
    </div>
  );
}