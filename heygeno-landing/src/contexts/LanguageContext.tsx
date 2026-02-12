import { createContext, useContext, useState, ReactNode } from 'react';

type Language = 'KOR' | 'ENG';

interface LanguageContextType {
  language: Language;
  setLanguage: (lang: Language) => void;
  t: (key: string) => string;
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

const translations: Record<Language, Record<string, string>> = {
  KOR: {
    // Navigation
    'nav.features': '기능',
    'nav.about': '소개',
    'nav.contact': '문의',
    
    // Hero
    'hero.brand': '헤이제노',
    'hero.headline1': '우리 아이에게',
    'hero.headline2': '좋은 건',
    'hero.headline3': '먹이고 싶고,',
    'hero.headline4': '가격은',
    'hero.headline5': '부담될 때',
    'hero.headline6': '가 있습니다.',
    'hero.subheadline1': '성분은 쉽게,',
    'hero.subheadline2': '가격은 합리적으로.',
    'hero.subheadline3': '헤이제노가 그 고민을 덜어드립니다.',
    'hero.cta.primary': '얼리 액세스 신청하기',
    'hero.cta.secondary': '출시 알림 받기',
    'hero.benefit1': '출시 시 포인트 제공',
    'hero.benefit2': '베타 사용자 우선 이용',
    'hero.benefit3': '가장 먼저 출시 소식 안내',
    'hero.phone.prelaunch': '출시 예정 화면',
    'hero.phone.launch': '2026년 3월 출시 예정',
    'hero.phone.score': '종합 점수',
    'hero.phone.scoreMax': '100점 만점',
    'hero.phone.warning': '위험 성분 감지',
    'hero.phone.priceCompare': '최저가 비교',
    'hero.phone.lowest': '최저가',
    'hero.phone.clickAnalysis': '탭하여 분석 보기',
    'hero.phone.clickAlert': '탭하여 알림 보기',
    
    // Problem Section
    'problem.title': '반려동물 보호자들의 고민',
    'problem.card1.title': '복잡한 성분 분석',
    'problem.card1.desc': '사료 포장지의 복잡한 성분표를 이해하기 어렵고, 어떤 것이 위험한지 알 수 없어요',
    'problem.card2.title': '과한 가격',
    'problem.card2.desc': '좋은 사료는 너무 비싸고, 할인 정보를 찾기 위해 여러 사이트를 돌아다녀야 해요',
    'problem.card3.title': '알레르기 위험',
    'problem.card3.desc': '우리 아이에게 맞지 않는 성분이 들어있는지 매번 확인하는 것이 부담스러워요',
    
    // Solution Section
    'solution.title': '헤이제노는 다르게 접근합니다.',
    'solution.step1.title': '성분 위험 분석',
    'solution.step1.desc': '유해 성분과 위험 요소를 자동으로 탐지하고 평가합니다',
    'solution.step2.title': '알레르겐 탐지',
    'solution.step2.desc': '우리 아이에게 위험한 알레르겐을 사전에 경고합니다',
    'solution.step3.title': '맞춤 영양 매칭',
    'solution.step3.desc': '나이, 체중, 건강 상태에 최적화된 영양 솔루션을 제공합니다',
    'solution.step4.title': '멀티플랫폼 가격 비교',
    'solution.step4.desc': '주요 플랫폼의 가격을 한눈에 비교하고 분석합니다',
    'solution.step5.title': '최저가 알림',
    'solution.step5.desc': '원하는 사료의 가격이 떨어지면 실시간으로 알려드립니다',
    'solution.step6.title': '리워드 포인트 시스템',
    'solution.step6.desc': '구매와 활동으로 포인트를 적립하고 사료로 교환하세요',
    'solution.demo': '데모 보기',
    
    // Reward Section
    'reward.main.title': '구매할수록\n더 똑똑해집니다.',
    'reward.main.desc': '구매와 이벤트 참여를 통해 포인트를 적립하고, 사료 또는 간식으로 교환할 수 있습니다.',
    'reward.earn1.title': '구매 적립',
    'reward.earn1.desc': '사료 구매 시 최대 5% 포인트 적립',
    'reward.earn2.title': '이벤트 참여',
    'reward.earn2.desc': '리뷰 작성, 제품 평가로 추가 포인트 획득',
    'reward.earn3.title': '포인트 교환',
    'reward.earn3.desc': '적립된 포인트로 사료 및 간식 구매 가능',
    'reward.card.mypoints': '내 포인트',
    'reward.card.recentearnings': '최근 적립 내역',
    'reward.card.today': '오늘',
    'reward.card.purchase': '사료 구매',
    'reward.card.review': '리뷰 작성',
    'reward.card.redeemable': '교환 가능 상품',
    'reward.card.food2kg': '사료 2kg',
    'reward.card.treats': '프리미엄 간식',
    'reward.card.button': '포인트 교환하기',
    
    // Vision Section
    'vision.title': '헤이제노가 만드는 미래',
    'vision.subtitle': '데이터 기반의 스마트한 반려동물 영양 관리',
    'vision.feature1.title': '투명한 성분 정보',
    'vision.feature1.desc': '모든 사료의 성분을 명확하게 분석하고 위험 요소를 미리 알려드립니다',
    'vision.feature2.title': '합리적인 가격',
    'vision.feature2.desc': '여러 플랫폼의 가격을 실시간으로 비교해 최저가를 찾아드립니다',
    'vision.feature3.title': '건강한 선택',
    'vision.feature3.desc': '반려동물의 건강 상태에 맞는 최적의 영양 솔루션을 제공합니다',
    'vision.expansion.badge': '확장 가능성',
    'vision.expansion.title': '장기적으로 성장하는\n데이터 기반 플랫폼',
    'vision.expansion.desc': '사료 분석부터 시작하여, 영양제, 건강 관리까지\n우리 아이의 전체 라이프사이클을 책임지는 플랫폼으로 발전합니다.',
    
    // Final CTA
    'finalcta.title': '지금 바로 시작하세요',
    'finalcta.subtitle': '사전 등록하고 특별 혜택을 받아보세요',
    'finalcta.button': '사전 등록하기',
    
    // Countdown
    'countdown.title': '곧 출시됩니다.',
    'countdown.timeframe': '1–2개월 내',
    'countdown.launch': '정식 출시 예정',
    'countdown.message': '지금 등록하면 가장 먼저 분석 기능을 경험할 수 있습니다.',
    
    // Social Proof
    'social.title': '이런 보호자를 위해 만들었습니다.',
    'social.user1.title': '성분을 제대로 확인하고 싶은 보호자',
    'social.user1.desc': '복잡한 사료 성분표를 정확하게 분석하고 이해하고 싶으신 분들을 위해',
    'social.user2.title': '알레르기가 걱정되는 반려가정',
    'social.user2.desc': '우리 아이에게 맞지 않는 성분과 알레르겐을 사전에 확인하고 싶으신 분들을 위해',
    'social.user3.title': '여러 플랫폼 가격을 비교하고 싶은 보호자',
    'social.user3.desc': '쿠팡, 네이버 등 다양한 플랫폼의 최저가를 한눈에 비교하고 싶으신 분들을 위해',
    
    // Final Reinforcement
    'final.title': '출시되면, 가장 먼저 분석해보세요.',
    'final.subtitle': '정식 출시 알림과 보너스 포인트 안내를 보내드립니다.',
    'final.button': '1,000P 확보하기',
  },
  ENG: {
    // Navigation
    'nav.features': 'Features',
    'nav.about': 'About',
    'nav.contact': 'Contact',
    
    // Hero
    'hero.brand': 'HeyZeno',
    'hero.headline1': 'We want to feed our pets',
    'hero.headline2': 'the best',
    'hero.headline3': ',',
    'hero.headline4': 'but the price',
    'hero.headline5': 'can be a burden',
    'hero.headline6': '.',
    'hero.subheadline1': 'Ingredients made simple,',
    'hero.subheadline2': 'Prices made reasonable.',
    'hero.subheadline3': 'HeyZeno takes care of your concerns.',
    'hero.cta.primary': 'Get Early Access',
    'hero.cta.secondary': 'Get Launch Alert',
    'hero.benefit1': 'Points on launch',
    'hero.benefit2': 'Beta access priority',
    'hero.benefit3': 'First to know about launch',
    'hero.phone.prelaunch': 'Pre-launch Preview',
    'hero.phone.launch': 'Launching March 2026',
    'hero.phone.score': 'Overall Score',
    'hero.phone.scoreMax': 'out of 100',
    'hero.phone.warning': 'Harmful Ingredients Detected',
    'hero.phone.priceCompare': 'Best Price',
    'hero.phone.lowest': 'Lowest',
    'hero.phone.clickAnalysis': 'Tap to see analysis',
    'hero.phone.clickAlert': 'Tap to see alert',
    
    // Problem Section
    'problem.title': "Pet Parents' Concerns",
    'problem.card1.title': 'Complex Ingredients',
    'problem.card1.desc': "It's hard to understand complicated ingredient lists and identify harmful components",
    'problem.card2.title': 'High Prices',
    'problem.card2.desc': 'Quality food is expensive, and finding deals requires browsing multiple sites',
    'problem.card3.title': 'Allergy Risks',
    'problem.card3.desc': "It's burdensome to check every time if ingredients are safe for my pet",
    
    // Solution Section
    'solution.title': 'HeyZeno Takes a Different Approach.',
    'solution.step1.title': 'Ingredient Risk Analysis',
    'solution.step1.desc': 'Automatically detect and evaluate harmful ingredients and risk factors',
    'solution.step2.title': 'Allergen Detection',
    'solution.step2.desc': 'Pre-warn about allergens that may be dangerous for your pet',
    'solution.step3.title': 'Custom Nutrition Matching',
    'solution.step3.desc': 'Provide optimized nutrition solutions based on age, weight, and health',
    'solution.step4.title': 'Multi-platform Price Comparison',
    'solution.step4.desc': 'Compare and analyze prices across major platforms at a glance',
    'solution.step5.title': 'Price Drop Alerts',
    'solution.step5.desc': 'Get real-time notifications when prices drop on your favorite foods',
    'solution.step6.title': 'Reward Points System',
    'solution.step6.desc': 'Earn points through purchases and activities, redeem for pet food',
    'solution.demo': 'View Demo',
    
    // Reward Section
    'reward.main.title': 'The More You Buy,\nThe Smarter We Get.',
    'reward.main.desc': 'Earn points through purchases and events, and redeem them for pet food or treats.',
    'reward.earn1.title': 'Purchase Rewards',
    'reward.earn1.desc': 'Earn up to 5% points on pet food purchases',
    'reward.earn2.title': 'Event Participation',
    'reward.earn2.desc': 'Earn additional points by writing reviews and rating products',
    'reward.earn3.title': 'Point Redemption',
    'reward.earn3.desc': 'Redeem accumulated points for pet food and treats',
    'reward.card.mypoints': 'My Points',
    'reward.card.recentearnings': 'Recent Earnings',
    'reward.card.today': 'Today',
    'reward.card.purchase': 'Pet Food Purchase',
    'reward.card.review': 'Review Written',
    'reward.card.redeemable': 'Redeemable Items',
    'reward.card.food2kg': '2kg Pet Food',
    'reward.card.treats': 'Premium Treats',
    'reward.card.button': 'Redeem Points',
    
    // Vision Section
    'vision.title': 'The Future HeyZeno Creates',
    'vision.subtitle': 'Data-driven smart pet nutrition management',
    'vision.feature1.title': 'Transparent Ingredients',
    'vision.feature1.desc': 'Clearly analyze all food ingredients and alert you to risk factors in advance',
    'vision.feature2.title': 'Reasonable Prices',
    'vision.feature2.desc': 'Compare prices across multiple platforms in real-time to find the best deal',
    'vision.feature3.title': 'Healthy Choices',
    'vision.feature3.desc': "Provide optimal nutrition solutions tailored to your pet's health condition",
    'vision.expansion.badge': 'Scalability',
    'vision.expansion.title': 'Growing Data-Driven\nPlatform',
    'vision.expansion.desc': 'Starting from food analysis, expanding to supplements and health management,\nbecoming a platform that takes care of your pet\'s entire lifecycle.',
    
    // Final CTA
    'finalcta.title': 'Start Right Now',
    'finalcta.subtitle': 'Pre-register and receive special benefits',
    'finalcta.button': 'Pre-register Now',
    
    // Countdown
    'countdown.title': 'Launching Soon',
    'countdown.timeframe': '1–2 months',
    'countdown.launch': 'Official Launch Expected',
    'countdown.message': 'Register now to be the first to experience the analysis feature.',
    
    // Social Proof
    'social.title': 'Made For Pet Parents Like You',
    'social.user1.title': 'For those who want to verify ingredients properly',
    'social.user1.desc': 'For those who want to accurately analyze and understand complex pet food ingredient lists',
    'social.user2.title': 'For families worried about allergies',
    'social.user2.desc': 'For those who want to check ingredients and allergens that may not suit their pet in advance',
    'social.user3.title': 'For those who want to compare prices across platforms',
    'social.user3.desc': 'For those who want to compare the lowest prices from various platforms like Coupang and Naver at a glance',
    
    // Final Reinforcement
    'final.title': 'When We Launch, Be The First To Analyze',
    'final.subtitle': "We'll notify you of the official launch and bonus points.",
    'final.button': 'Get 1,000P Now',
  },
};

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [language, setLanguage] = useState<Language>('KOR');

  const t = (key: string): string => {
    return translations[language][key] || key;
  };

  return (
    <LanguageContext.Provider value={{ language, setLanguage, t }}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error('useLanguage must be used within LanguageProvider');
  }
  return context;
}