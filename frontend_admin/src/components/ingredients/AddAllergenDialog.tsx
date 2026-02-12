import { useState, useEffect } from 'react';
import { X } from 'lucide-react';
import { Product } from '../../data/mockProducts';
import { productService } from '../../services/productService';
import { ApiError } from '../../config/api';
import { toast } from 'sonner@2.0.3';

interface AddAllergenDialogProps {
  product: Product;
  onClose: () => void;
  onSave: (allergenCode: string) => Promise<void>;
}

export function AddAllergenDialog({ product, onClose, onSave }: AddAllergenDialogProps) {
  const [allergenCodes, setAllergenCodes] = useState<any[]>([]);
  const [selectedAllergenCode, setSelectedAllergenCode] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadAllergenCodes();
  }, []);

  const loadAllergenCodes = async () => {
    try {
      setLoading(true);
      const codes = await productService.getAllergenCodes();
      setAllergenCodes(codes);
    } catch (err) {
      const errorMessage = err instanceof ApiError 
        ? `코드 목록 로드 실패: ${err.status} ${err.statusText}`
        : '알레르겐 코드 목록을 불러오는데 실패했습니다.';
      toast.error(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  const handleAdd = async () => {
    if (!selectedAllergenCode) {
      toast.error('알레르겐을 선택하세요.');
      return;
    }
    await onSave(selectedAllergenCode);
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-gray-200">
          <h3 className="text-lg font-bold text-gray-900">알레르겐 추가</h3>
          <button
            onClick={onClose}
            className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <X className="w-5 h-5 text-gray-600" />
          </button>
        </div>

        {/* Content */}
        <div className="px-6 py-6 space-y-4">
          {loading ? (
            <div className="text-center py-8 text-gray-500">로딩 중...</div>
          ) : (
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                알레르겐 코드 선택
              </label>
              <select
                value={selectedAllergenCode}
                onChange={(e) => setSelectedAllergenCode(e.target.value)}
                className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">선택하세요</option>
                {allergenCodes.map((code) => (
                  <option key={code.code || code.allergen_code} value={code.code || code.allergen_code}>
                    {code.name || code.allergen_name || code.code || code.allergen_code}
                  </option>
                ))}
              </select>
            </div>
          )}
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
            disabled={!selectedAllergenCode || loading}
            className="admin-btn px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white disabled:opacity-50 disabled:cursor-not-allowed"
          >
            추가
          </button>
        </div>
      </div>
    </div>
  );
}