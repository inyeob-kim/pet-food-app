import { useState } from 'react';
import { X } from 'lucide-react';
import { Product } from '../../data/mockProducts';
import { productService } from '../../services/productService';
import { ApiError } from '../../config/api';
import { toast } from 'sonner@2.0.3';

interface EditProductDialogProps {
  product: Product;
  onClose: () => void;
  onSave: (product: Product) => void;
}

export function EditProductDialog({ product, onClose, onSave }: EditProductDialogProps) {
  const [formData, setFormData] = useState({
    name: product.name,
    brand: product.brand,
    species: product.species,
    status: product.status,
    sizeLabel: product.sizeLabel || '',
    category: product.category || 'FOOD',
  });

  const [activeTab, setActiveTab] = useState<'basic' | 'nutrition' | 'other'>('basic');
  const [loading, setLoading] = useState(false);

  const handleSave = async () => {
    try {
      setLoading(true);
      const updated = await productService.updateProduct({
        id: product.id,
        productName: formData.name,
        brandName: formData.brand,
        sizeLabel: formData.sizeLabel || undefined,
        category: formData.category || undefined,
        species: formData.species,
        isActive: formData.status === 'ACTIVE',
      });
      onSave(updated);
      toast.success('상품이 수정되었습니다.');
    } catch (err) {
      const errorMessage = err instanceof ApiError 
        ? `수정 실패: ${err.status} ${err.statusText}`
        : '상품 수정에 실패했습니다.';
      toast.error(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-gray-200">
          <h2 className="text-xl font-bold text-gray-900">상품 수정</h2>
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
                    상태 *
                  </label>
                  <select
                    value={formData.status}
                    onChange={(e) => setFormData({ ...formData, status: e.target.value as 'ACTIVE' | 'ARCHIVED' })}
                    className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="ACTIVE">활성</option>
                    <option value="ARCHIVED">비활성</option>
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    용량 표기
                  </label>
                  <input
                    type="text"
                    value={formData.sizeLabel}
                    onChange={(e) => setFormData({ ...formData, sizeLabel: e.target.value })}
                    className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="예: 2kg, 7.5kg"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    카테고리
                  </label>
                  <input
                    type="text"
                    value={formData.category}
                    onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                    className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="예: FOOD"
                  />
                </div>
              </div>
            </div>
          )}

          {activeTab === 'nutrition' && (
            <div className="text-center py-12 text-gray-500">
              <p>영양 정보 편집 UI</p>
              <p className="text-sm mt-2">(구현 예정)</p>
            </div>
          )}

          {activeTab === 'other' && (
            <div className="text-center py-12 text-gray-500">
              <p>기타 정보 편집 UI</p>
              <p className="text-sm mt-2">(구현 예정)</p>
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
            onClick={handleSave}
            disabled={loading}
            className="admin-btn px-6 py-2 bg-blue-500 hover:bg-blue-600 text-white disabled:opacity-50"
          >
            {loading ? '저장 중...' : '저장'}
          </button>
        </div>
      </div>
    </div>
  );
}
