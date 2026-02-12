export interface Product {
  id: string;
  name: string;
  brand: string;
  species: 'DOG' | 'CAT';
  status: 'ACTIVE' | 'ARCHIVED';
  sizeLabel?: string;
  category?: string;
  thumbnail: string;
  createdAt: string;
  updatedAt: string;
  offerSource: string;
  ingredients: string[];
  nutrition: Record<string, string>;
  allergens: string[];
  claims: string[];
  offers: Array<{
    id: string;
    platform: string;
    url: string;
    price: number;
  }>;
  images: string[];
}

export const mockProducts: Product[] = [
  {
    id: 'prod_001',
    name: '로얄캐닌 미니 어덜트',
    brand: '로얄캐닌',
    species: 'DOG',
    status: 'ACTIVE',
    thumbnail: 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=200&h=200&fit=crop',
    createdAt: '2025-01-15T10:30:00Z',
    updatedAt: '2026-02-10T14:20:00Z',
    offerSource: 'COUPANG',
    ingredients: ['닭고기', '쌀', '옥수수', '비트펄프', '어유'],
    nutrition: {
      '단백질': '27%',
      '지방': '16%',
      '섬유질': '3%',
      '칼슘': '1.2%',
    },
    allergens: ['닭고기', '옥수수'],
    claims: ['관절 건강', '피부/털 건강', '소화기 건강'],
    offers: [
      { id: 'off_001', platform: '쿠팡', url: 'https://coupang.com/...', price: 45000 },
    ],
    images: ['https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=400&h=400&fit=crop'],
  },
  {
    id: 'prod_002',
    name: '힐스 사이언스 다이어트 어덜트',
    brand: '힐스',
    species: 'DOG',
    status: 'ACTIVE',
    thumbnail: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=200&h=200&fit=crop',
    createdAt: '2025-02-01T09:15:00Z',
    updatedAt: '2026-02-11T16:45:00Z',
    offerSource: 'COUPANG',
    ingredients: ['닭고기', '현미', '귀리', '당근', '연어유'],
    nutrition: {
      '단백질': '24%',
      '지방': '14%',
      '섬유질': '4%',
      '칼슘': '1.0%',
    },
    allergens: ['닭고기'],
    claims: ['체중 관리', '소화기 건강'],
    offers: [
      { id: 'off_002', platform: '쿠팡', url: 'https://coupang.com/...', price: 52000 },
    ],
    images: ['https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=400&h=400&fit=crop'],
  },
  {
    id: 'prod_003',
    name: '오리젠 오리지널 캣',
    brand: '오리젠',
    species: 'CAT',
    status: 'ACTIVE',
    thumbnail: 'https://images.unsplash.com/photo-1595433707802-6b2626ef1c91?w=200&h=200&fit=crop',
    createdAt: '2025-01-20T11:00:00Z',
    updatedAt: '2026-02-09T13:30:00Z',
    offerSource: 'COUPANG',
    ingredients: ['닭고기', '칠면조', '연어', '청어', '달걀'],
    nutrition: {
      '단백질': '40%',
      '지방': '20%',
      '섬유질': '3%',
      '칼슘': '1.4%',
    },
    allergens: ['닭고기', '달걀'],
    claims: ['고단백', '그레인프리'],
    offers: [
      { id: 'off_003', platform: '쿠팡', url: 'https://coupang.com/...', price: 68000 },
    ],
    images: ['https://images.unsplash.com/photo-1595433707802-6b2626ef1c91?w=400&h=400&fit=crop'],
  },
  {
    id: 'prod_004',
    name: '퓨리나 프로플랜 센서티브',
    brand: '퓨리나',
    species: 'DOG',
    status: 'ACTIVE',
    thumbnail: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=200&h=200&fit=crop',
    createdAt: '2025-01-25T14:30:00Z',
    updatedAt: '2026-02-08T10:15:00Z',
    offerSource: 'ETC',
    ingredients: ['연어', '쌀', '보리', '어유', '비타민'],
    nutrition: {
      '단백질': '26%',
      '지방': '16%',
      '섬유질': '3.5%',
      '칼슘': '1.1%',
    },
    allergens: ['연어'],
    claims: ['민감성 피부', '소화기 건강'],
    offers: [
      { id: 'off_004', platform: '네이버쇼핑', url: 'https://shopping.naver.com/...', price: 48000 },
    ],
    images: ['https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400&h=400&fit=crop'],
  },
  {
    id: 'prod_005',
    name: '내추럴발란스 포뮬라',
    brand: '내추럴발란스',
    species: 'CAT',
    status: 'ARCHIVED',
    thumbnail: 'https://images.unsplash.com/photo-1573865526739-10c1dd843895?w=200&h=200&fit=crop',
    createdAt: '2024-12-10T08:00:00Z',
    updatedAt: '2026-01-15T09:00:00Z',
    offerSource: 'COUPANG',
    ingredients: ['참치', '닭고기', '완두콩', '고구마'],
    nutrition: {
      '단백질': '32%',
      '지방': '15%',
      '섬유질': '4%',
      '칼슘': '1.0%',
    },
    allergens: ['닭고기', '참치'],
    claims: ['그레인프리'],
    offers: [],
    images: ['https://images.unsplash.com/photo-1573865526739-10c1dd843895?w=400&h=400&fit=crop'],
  },
];
