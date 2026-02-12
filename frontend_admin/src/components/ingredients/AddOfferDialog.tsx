import { useState } from 'react';
import { X } from 'lucide-react';
import { Product } from '../../data/mockProducts';

interface AddOfferDialogProps {
  product: Product;
  onClose: () => void;
  onSave: (offerData: any) => Promise<void>;
  initialData?: {
    platform?: string;
    url?: string;
    price?: number;
  };
  mode?: 'add' | 'edit';
}

export function AddOfferDialog({ product, onClose, onSave, initialData, mode = 'add' }: AddOfferDialogProps) {
  const [formData, setFormData] = useState({
    platform: initialData?.platform || '쿠팡',
    url: initialData?.url || '',
    price: initialData?.price || 0,
  });

  const handleAdd = async () => {
    if (formData.platform && formData.url && formData.price > 0) {
      await onSave({
        platform: formData.platform,
        url: formData.url,
        price: formData.price,
      });
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-gray-200">
          <h3 className="text-lg font-bold text-gray-900">{mode === 'edit' ? '판매처 수정' : '판매처 추가'}</h3>
          <button
            onClick={onClose}
            className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <X className="w-5 h-5 text-gray-600" />
          </button>
        </div>

        {/* Content */}
        <div className="px-6 py-6 space-y-4">
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              플랫폼 *
            </label>
            <select
              value={formData.platform}
              onChange={(e) => setFormData({ ...formData, platform: e.target.value })}
              className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="쿠팡">쿠팡</option>
              <option value="네이버쇼핑">네이버쇼핑</option>
              <option value="11번가">11번가</option>
              <option value="G마켓">G마켓</option>
              <option value="옥션">옥션</option>
              <option value="기타">기타</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              상품 URL *
            </label>
            <input
              type="url"
              value={formData.url}
              onChange={(e) => setFormData({ ...formData, url: e.target.value })}
              className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="https://..."
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              가격 (원) *
            </label>
            <input
              type="number"
              value={formData.price || ''}
              onChange={(e) => setFormData({ ...formData, price: parseInt(e.target.value) || 0 })}
              className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="0"
              min="0"
            />
          </div>
        </div>

        {/* Footer */}
        <div className="flex items-center justify-end gap-2 px-6 py-4 border-t border-gray-200">
          <button
            onClick={onClose}
            className="admin-btn px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700"
          >
            취소
          </button>
          <button
            onClick={handleAdd}
            disabled={!formData.platform || !formData.url || formData.price <= 0}
            className="admin-btn px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {mode === 'edit' ? '수정' : '추가'}
          </button>
        </div>
      </div>
    </div>
  );
}