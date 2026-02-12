import { useState, useEffect } from 'react';
import { X, Loader2, AlertCircle, CheckCircle, Shield, Award, XCircle, Info } from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';
import productImage from 'figma:asset/1f513950e90391a568bd6fbe59d74c33c122cf66.png';

interface AnalysisSimulationModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export function AnalysisSimulationModal({ isOpen, onClose }: AnalysisSimulationModalProps) {
  const [stage, setStage] = useState(0);
  const [ingredientCount, setIngredientCount] = useState(0);

  useEffect(() => {
    if (!isOpen) {
      setStage(0);
      setIngredientCount(0);
      return;
    }

    // 초기화
    setStage(0);
    setIngredientCount(0);

    // Stage timers - 모달이 열릴 때 한 번만 설정
    const stageTimers = [
      setTimeout(() => setStage(1), 1500),  // Stage 1: 1.5s
      setTimeout(() => setStage(2), 3500),  // Stage 2: 3.5s
      setTimeout(() => setStage(3), 6500),  // Stage 3: 6.5s
      setTimeout(() => setStage(4), 9500),  // Stage 4: 9.5s
      setTimeout(() => setStage(5), 12000), // Stage 5: 12s
    ];

    return () => {
      stageTimers.forEach(timer => clearTimeout(timer));
    };
  }, [isOpen]);

  // Ingredient count animation - stage 1일 때만
  useEffect(() => {
    if (stage !== 1) return;

    let count = 0;
    const countInterval = setInterval(() => {
      count += 2;
      if (count >= 36) {
        count = 36;
        clearInterval(countInterval);
      }
      setIngredientCount(count);
    }, 50);

    return () => clearInterval(countInterval);
  }, [stage]);

  if (!isOpen) return null;

  const totalStages = 5;
  const stageLabels = [
    '성분 스캔',
    '알레르기 검사',
    '유해 성분 분석',
    '품질 평가',
    '종합 판정'
  ];

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm" onClick={onClose}>
      <div 
        className="bg-white rounded-3xl shadow-2xl max-w-3xl w-full max-h-[90vh] overflow-y-auto relative scrollbar-hide"
        onClick={(e) => e.stopPropagation()}
        style={{
          scrollbarWidth: 'none',
          msOverflowStyle: 'none',
        }}
      >
        {/* Close Button */}
        <button
          onClick={onClose}
          className="absolute top-6 right-6 w-10 h-10 rounded-full bg-gray-100 hover:bg-gray-200 transition-colors flex items-center justify-center z-10"
        >
          <X className="w-5 h-5" style={{ color: '#475569' }} />
        </button>

        {/* Content */}
        <div className="p-8 lg:p-12">
          {/* Header */}
          <div className="text-center mb-8">
            <h2 className="text-3xl lg:text-4xl font-bold mb-3" style={{ color: '#0F172A' }}>
              제노에게 맞는 사료 분석
            </h2>
            <p className="text-lg" style={{ color: '#475569' }}>
              말티즈, 3세 · 3.2kg
            </p>
          </div>

          {/* Progress Steps */}
          <div className="mb-8">
            <div className="flex items-center justify-between mb-3">
              {[1, 2, 3, 4, 5].map((step) => (
                <div key={step} className="flex-1 flex items-center">
                  <div className="flex flex-col items-center flex-1">
                    <div 
                      className={`w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm transition-all duration-500 ${
                        stage >= step 
                          ? 'text-white scale-110' 
                          : 'bg-gray-200 text-gray-400'
                      }`}
                      style={stage >= step ? { backgroundColor: '#2563EB' } : {}}
                    >
                      {stage > step ? <CheckCircle className="w-5 h-5" /> : step}
                    </div>
                    <div className="text-xs mt-2 text-center" style={{ color: stage >= step ? '#2563EB' : '#94A3B8' }}>
                      {stageLabels[step - 1]}
                    </div>
                  </div>
                  {step < 5 && (
                    <div 
                      className="h-1 flex-1 mx-2 rounded transition-all duration-500"
                      style={{ backgroundColor: stage > step ? '#2563EB' : '#E5E7EB' }}
                    />
                  )}
                </div>
              ))}
            </div>
          </div>

          {/* Product Card */}
          <div className="bg-gradient-to-br from-gray-50 to-gray-100 rounded-2xl p-6 mb-8">
            <div className="flex items-center gap-6">
              <div className="w-32 h-32 rounded-xl overflow-hidden shadow-md bg-white flex-shrink-0">
                <img
                  src={productImage}
                  alt="사료"
                  className="w-full h-full object-contain"
                />
              </div>
              <div className="flex-1">
                <h3 className="text-xl font-bold mb-2" style={{ color: '#0F172A' }}>
                  헤이제노 강아지 사료
                </h3>
                <p className="text-sm mb-3" style={{ color: '#475569' }}>
                  소형견 성견용 · 2kg
                </p>
                <div className="flex gap-2">
                  <span className="px-3 py-1 rounded-full text-xs font-semibold bg-white" style={{ color: '#2563EB' }}>
                    소형견
                  </span>
                  <span className="px-3 py-1 rounded-full text-xs font-semibold bg-white" style={{ color: '#14B8A6' }}>
                    성견용
                  </span>
                </div>
              </div>
              <div className="flex flex-col items-center gap-2">
                <div className="w-16 h-16 rounded-full flex items-center justify-center" style={{ backgroundColor: '#EFF6FF' }}>
                  <ImageWithFallback
                    src="https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=200&h=200&fit=crop"
                    alt="제노"
                    className="w-14 h-14 rounded-full object-cover"
                  />
                </div>
                <span className="text-xs font-semibold" style={{ color: '#475569' }}>제노</span>
              </div>
            </div>
          </div>

          {/* Analysis Sections */}
          <div className="space-y-6">
            {/* Stage 1: 성분 스캔 */}
            {stage >= 1 && (
              <div className="border-2 rounded-2xl p-6 animate-fade-in" style={{ borderColor: stage === 1 ? '#2563EB' : '#E5E7EB' }}>
                <div className="flex items-center gap-3 mb-4">
                  <div className="w-10 h-10 rounded-full flex items-center justify-center" style={{ backgroundColor: '#EFF6FF' }}>
                    {stage === 1 ? (
                      <Loader2 className="w-5 h-5 animate-spin" style={{ color: '#2563EB' }} />
                    ) : (
                      <CheckCircle className="w-5 h-5" style={{ color: '#14B8A6' }} />
                    )}
                  </div>
                  <div className="flex-1">
                    <h4 className="font-bold text-lg" style={{ color: '#0F172A' }}>
                      1. 성분 스캔
                    </h4>
                    <p className="text-sm" style={{ color: '#475569' }}>
                      {stage === 1 ? '원재료 분석 중...' : '분석 완료'}
                    </p>
                  </div>
                  {stage > 1 && (
                    <div className="px-4 py-2 rounded-lg text-sm font-semibold" style={{ backgroundColor: '#F0FDF4', color: '#14B8A6' }}>
                      완료
                    </div>
                  )}
                </div>
                {stage >= 1 && (
                  <div className="pl-13 text-sm" style={{ color: '#475569' }}>
                    <div className="font-semibold mb-2">검출된 성분: {stage === 1 ? ingredientCount : 36}개</div>
                    <div className="flex flex-wrap gap-2 mt-3">
                      {['닭고기', '쌀', '옥수수', '비트펄프', '닭지방', '밀'].map((ing) => (
                        <span key={ing} className="px-3 py-1 rounded-full text-xs bg-gray-100" style={{ color: '#475569' }}>
                          {ing}
                        </span>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* Stage 2: 알레르기 검사 */}
            {stage >= 2 && (
              <div className="border-2 rounded-2xl p-6 animate-fade-in" style={{ borderColor: stage === 2 ? '#EF4444' : '#E5E7EB' }}>
                <div className="flex items-center gap-3 mb-4">
                  <div className="w-10 h-10 rounded-full flex items-center justify-center" style={{ backgroundColor: '#FEF2F2' }}>
                    {stage === 2 ? (
                      <Loader2 className="w-5 h-5 animate-spin" style={{ color: '#EF4444' }} />
                    ) : (
                      <AlertCircle className="w-5 h-5" style={{ color: '#EF4444' }} />
                    )}
                  </div>
                  <div className="flex-1">
                    <h4 className="font-bold text-lg" style={{ color: '#0F172A' }}>
                      2. 알레르기 검사
                    </h4>
                    <p className="text-sm" style={{ color: '#475569' }}>
                      {stage === 2 ? '제노의 알레르기 성분 대조 중...' : '알레르기 성분 발견'}
                    </p>
                  </div>
                  {stage > 2 && (
                    <div className="px-4 py-2 rounded-lg text-sm font-semibold" style={{ backgroundColor: '#FEF2F2', color: '#EF4444' }}>
                      ⚠️ 위험
                    </div>
                  )}
                </div>
                {stage > 2 && (
                  <div className="pl-13">
                    <div className="bg-red-50 rounded-xl p-4 space-y-2">
                      <div className="flex items-start gap-2">
                        <XCircle className="w-5 h-5 flex-shrink-0 mt-0.5" style={{ color: '#EF4444' }} />
                        <div>
                          <div className="font-semibold text-sm mb-1" style={{ color: '#0F172A' }}>옥수수 (Corn)</div>
                          <div className="text-xs" style={{ color: '#475569' }}>제노의 알레르기 성분</div>
                        </div>
                      </div>
                      <div className="flex items-start gap-2">
                        <XCircle className="w-5 h-5 flex-shrink-0 mt-0.5" style={{ color: '#EF4444' }} />
                        <div>
                          <div className="font-semibold text-sm mb-1" style={{ color: '#0F172A' }}>밀 (Wheat)</div>
                          <div className="text-xs" style={{ color: '#475569' }}>제노의 알레르기 성분</div>
                        </div>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* Stage 3: 유해 성분 분석 */}
            {stage >= 3 && (
              <div className="border-2 rounded-2xl p-6 animate-fade-in" style={{ borderColor: stage === 3 ? '#F97316' : '#E5E7EB' }}>
                <div className="flex items-center gap-3 mb-4">
                  <div className="w-10 h-10 rounded-full flex items-center justify-center" style={{ backgroundColor: '#FFF7ED' }}>
                    {stage === 3 ? (
                      <Loader2 className="w-5 h-5 animate-spin" style={{ color: '#F97316' }} />
                    ) : (
                      <Info className="w-5 h-5" style={{ color: '#F97316' }} />
                    )}
                  </div>
                  <div className="flex-1">
                    <h4 className="font-bold text-lg" style={{ color: '#0F172A' }}>
                      3. 유해 성분 분석
                    </h4>
                    <p className="text-sm" style={{ color: '#475569' }}>
                      {stage === 3 ? '보존제 및 첨가물 검사 중...' : '주의 성분 검출'}
                    </p>
                  </div>
                  {stage > 3 && (
                    <div className="px-4 py-2 rounded-lg text-sm font-semibold" style={{ backgroundColor: '#FFF7ED', color: '#F97316' }}>
                      주의
                    </div>
                  )}
                </div>
                {stage > 3 && (
                  <div className="pl-13">
                    <div className="bg-orange-50 rounded-xl p-4">
                      <div className="flex items-start gap-2">
                        <AlertCircle className="w-5 h-5 flex-shrink-0 mt-0.5" style={{ color: '#F97316' }} />
                        <div>
                          <div className="font-semibold text-sm mb-1" style={{ color: '#0F172A' }}>BHA (부틸화 하이드록시아니솔)</div>
                          <div className="text-xs" style={{ color: '#475569' }}>장기 섭취 시 주의가 필요한 합성 보존제</div>
                        </div>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* Stage 4: 품질 평가 */}
            {stage >= 4 && (
              <div className="border-2 rounded-2xl p-6 animate-fade-in" style={{ borderColor: stage === 4 ? '#2563EB' : '#E5E7EB' }}>
                <div className="flex items-center gap-3 mb-4">
                  <div className="w-10 h-10 rounded-full flex items-center justify-center" style={{ backgroundColor: '#EFF6FF' }}>
                    {stage === 4 ? (
                      <Loader2 className="w-5 h-5 animate-spin" style={{ color: '#2563EB' }} />
                    ) : (
                      <Shield className="w-5 h-5" style={{ color: '#2563EB' }} />
                    )}
                  </div>
                  <div className="flex-1">
                    <h4 className="font-bold text-lg" style={{ color: '#0F172A' }}>
                      4. 품질 평가
                    </h4>
                    <p className="text-sm" style={{ color: '#475569' }}>
                      {stage === 4 ? '영양 균형 및 품질 평가 중...' : '평가 완료'}
                    </p>
                  </div>
                  {stage > 4 && (
                    <div className="px-4 py-2 rounded-lg text-sm font-semibold" style={{ backgroundColor: '#F0FDF4', color: '#14B8A6' }}>
                      완료
                    </div>
                  )}
                </div>
                {stage > 4 && (
                  <div className="pl-13 space-y-3">
                    <div className="flex items-center gap-2 text-sm">
                      <CheckCircle className="w-4 h-4" style={{ color: '#14B8A6' }} />
                      <span style={{ color: '#475569' }}>첫 성분: 동물성 단백질 (닭고기)</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm">
                      <CheckCircle className="w-4 h-4" style={{ color: '#14B8A6' }} />
                      <span style={{ color: '#475569' }}>단백질 함량: 적정 수준</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm">
                      <CheckCircle className="w-4 h-4" style={{ color: '#14B8A6' }} />
                      <span style={{ color: '#475569' }}>하루 권장 급여량: 약 68g</span>
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* Stage 5: 종합 판정 */}
            {stage >= 5 && (
              <div className="border-2 rounded-2xl overflow-hidden animate-fade-in" style={{ borderColor: '#EF4444' }}>
                <div className="bg-gradient-to-r from-red-500 to-orange-500 p-6 text-white">
                  <div className="flex items-center gap-4 mb-6">
                    <Award className="w-12 h-12" />
                    <div>
                      <h4 className="font-bold text-2xl mb-1">종합 판정</h4>
                      <p className="text-sm opacity-90">AI 기반 맞춤 분석 결과</p>
                    </div>
                  </div>
                  
                  <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 text-center">
                    <div className="text-6xl font-bold mb-2">64점</div>
                    <div className="text-lg font-semibold mb-3">100점 만점</div>
                    <div className="inline-block px-6 py-2 rounded-full text-sm font-bold bg-white/20">
                      ❌ 제노에게 권장하지 않음
                    </div>
                  </div>
                </div>

                <div className="p-6 bg-gray-50">
                  <div className="font-bold text-lg mb-4" style={{ color: '#0F172A' }}>
                    권장하지 않는 이유
                  </div>
                  <div className="space-y-3">
                    <div className="flex items-start gap-3 p-3 bg-white rounded-lg">
                      <div className="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#FEE2E2' }}>
                        <span className="text-xs font-bold" style={{ color: '#EF4444' }}>1</span>
                      </div>
                      <p className="text-sm" style={{ color: '#475569' }}>
                        제노의 알레르기 성분(옥수수, 밀) <strong>2개 포함</strong>
                      </p>
                    </div>
                    <div className="flex items-start gap-3 p-3 bg-white rounded-lg">
                      <div className="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#FEE2E2' }}>
                        <span className="text-xs font-bold" style={{ color: '#EF4444' }}>2</span>
                      </div>
                      <p className="text-sm" style={{ color: '#475569' }}>
                        주의 필요 보존제 <strong>BHA 검출</strong>
                      </p>
                    </div>
                    <div className="flex items-start gap-3 p-3 bg-white rounded-lg">
                      <div className="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0" style={{ backgroundColor: '#FEE2E2' }}>
                        <span className="text-xs font-bold" style={{ color: '#EF4444' }}>3</span>
                      </div>
                      <p className="text-sm" style={{ color: '#475569' }}>
                        알레르기 반응 위험으로 <strong>다른 사료 권장</strong>
                      </p>
                    </div>
                  </div>
                </div>

                <div className="p-6 bg-white border-t-2" style={{ borderColor: '#E5E7EB' }}>
                  <a
                    href="https://forms.gle/sniAUJaSQktvAjzH6"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="block w-full py-4 rounded-xl text-white font-semibold text-center shadow-lg hover:shadow-xl transition-all text-lg"
                    style={{ backgroundColor: '#2563EB' }}
                  >
                    제노에게 맞는 사료 추천받기 →
                  </a>
                  <p className="text-xs text-center mt-3" style={{ color: '#94A3B8' }}>
                    사전 등록 시 1,000P 리워드 제공
                  </p>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>

      <style>{`
        @keyframes fade-in {
          from { opacity: 0; transform: translateY(20px); }
          to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in {
          animation: fade-in 0.6s ease-out;
        }
      `}</style>
    </div>
  );
}