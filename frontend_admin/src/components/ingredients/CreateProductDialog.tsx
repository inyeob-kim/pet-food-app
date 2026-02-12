import { useState } from 'react';
import { X } from 'lucide-react';
import { Product } from '../../data/mockProducts';

interface CreateProductDialogProps {
  onClose: () => void;
  onCreate: (product: Omit<Product, 'id' | 'createdAt' | 'updatedAt'>) => void;
}

export function CreateProductDialog({ onClose, onCreate }: CreateProductDialogProps) {
  const [formData, setFormData] = useState({
    name: '',
    brand: '',
    species: 'DOG' as 'DOG' | 'CAT',
    status: 'ACTIVE' as 'ACTIVE' | 'ARCHIVED',
    thumbnail: '',
    offerSource: 'COUPANG',
  });

  const [activeTab, setActiveTab] = useState<'basic' | 'nutrition' | 'other'>('basic');

  const handleCreate = () => {
    if (!formData.name || !formData.brand) {
      return;
    }

    onCreate({
      ...formData,
      thumbnail: formData.thumbnail || 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=200&h=200&fit=crop',
      ingredients: [],
      nutrition: {},
      allergens: [],
      claims: [],
      offers: [],
      images: [],
    });
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-gray-200">
          <h2 className="text-xl font-bold text-gray-900">새 상품 생성</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <X className="w-5 h-5 text-gray-600" />
          </button>
        </div>

        {/* Tabs */}
        <div className="flex gap-1 px-6 pt-4 border-b border-gray-200">
          <button
            onClick={() => setActiveTab('basic')}
            className={`px-4 py-2 text-sm font-semibold rounded-t-lg transition-colors ${
              activeTab === 'basic'
                ? 'bg-white text-blue-600 border-b-2 border-blue-600'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            기본정보
          </button>
          <button
            onClick={() => setActiveTab('nutrition')}
            className={`px-4 py-2 text-sm font-semibold rounded-t-lg transition-colors ${
              activeTab === 'nutrition'
                ? 'bg-white text-blue-600 border-b-2 border-blue-600'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            영양
          </button>
          <button
            onClick={() => setActiveTab('other')}
            className={`px-4 py-2 text-sm font-semibold rounded-t-lg transition-colors ${
              activeTab === 'other'
                ? 'bg-white text-blue-600 border-b-2 border-blue-600'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            기타
          </button>
        </div>

        {/* Content */}
        <div className="px-6 py-6 overflow-y-auto max-h-[calc(90vh-200px)]">
          {activeTab === 'basic' && (
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  상품명 *
                </label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="상품명을 입력하세요"
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  브랜드 *
                </label>
                <input
                  type="text"
                  value={formData.brand}
                  onChange={(e) => setFormData({ ...formData, brand: e.target.value })}
                  className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="브랜드명을 입력하세요"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    대상 동물 *
                  </label>
                  <select
                    value={formData.species}
                    onChange={(e) => setFormData({ ...formData, species: e.target.value as 'DOG' | 'CAT' })}
                    className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="DOG">강아지</option>
                    <option value="CAT">고양이</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    판매처
                  </label>
                  <select
                    value={formData.offerSource}
                    onChange={(e) => setFormData({ ...formData, offerSource: e.target.value })}
                    className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="COUPANG">쿠팡</option>
                    <option value="ETC">기타</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  썸네일 URL
                </label>
                <input
                  type="text"
                  value={formData.thumbnail}
                  onChange={(e) => setFormData({ ...formData, thumbnail: e.target.value })}
                  className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="https://..."
                />
              </div>
            </div>
          )}

          {activeTab === 'nutrition' && (
            <div className="text-center py-12 text-gray-500">
              <p>영양 정보는 상품 생성 후 수정 가능합니다</p>
            </div>
          )}

          {activeTab === 'other' && (
            <div className="text-center py-12 text-gray-500">
              <p>기타 정보는 상품 생성 후 추가 가능합니다</p>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="flex items-center justify-end gap-2 px-6 py-4 border-t border-gray-200">
          <button
            onClick={onClose}
            className="admin-btn px-6 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700"
          >
            취소
          </button>
          <button
            onClick={handleCreate}
            disabled={!formData.name || !formData.brand}
            className="admin-btn px-6 py-2 bg-blue-500 hover:bg-blue-600 text-white disabled:opacity-50 disabled:cursor-not-allowed"
          >
            생성
          </button>
        </div>
      </div>
    </div>
  );
}
