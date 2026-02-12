import { useState, useEffect } from 'react';
import { X } from 'lucide-react';
import { Product } from '../../data/mockProducts';
import { productService } from '../../services/productService';
import { ApiError } from '../../config/api';
import { toast } from 'sonner@2.0.3';

interface EditIngredientDialogProps {
  product: Product;
  onClose: () => void;
  onSave: () => void;
}

export function EditIngredientDialog({ product, onClose, onSave }: EditIngredientDialogProps) {
  const [formData, setFormData] = useState({
    ingredients_text: '',
    additives_text: '',
    source: '',
  });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    loadIngredientData();
  }, []);

  const loadIngredientData = async () => {
    try {
      setLoading(true);
      const data = await productService.getIngredient(product.id);
      if (data) {
        setFormData({
          ingredients_text: data.ingredients_text || '',
          additives_text: data.additives_text || '',
          source: data.source || '',
        });
      }
    } catch (err) {
      // 성분 정보가 없을 수 있음
      console.log('성분 정보 없음');
    } finally {
      setLoading(false);
    }
  };

  const handleSave = async () => {
    try {
      setSaving(true);
      
      // 최소 주요 성분은 입력되어야 함
      const trimmedIngredients = formData.ingredients_text.trim();
      if (!trimmedIngredients) {
        toast.error('주요 성분 텍스트를 입력해주세요.');
        return;
      }
      
      // 백엔드 스키마에 맞게 데이터 구성
      const updateData: any = {
        ingredients_text: trimmedIngredients,
      };
      
      // 선택 필드는 빈 문자열이 아니면 추가, 아니면 null로 명시
      const trimmedAdditives = formData.additives_text.trim();
      updateData.additives_text = trimmedAdditives || null;
      
      const trimmedSource = formData.source.trim();
      updateData.source = trimmedSource || null;
      
      await productService.updateIngredient(product.id, updateData);
      toast.success('성분 정보가 저장되었습니다.');
      onSave();
      onClose();
    } catch (err) {
      const errorMessage = err instanceof ApiError 
        ? `저장 실패: ${err.status} ${err.statusText}`
        : '성분 정보 저장에 실패했습니다.';
      toast.error(errorMessage);
      console.error('성분 정보 저장 실패:', err);
      
      // 에러 상세 정보 로깅
      if (err instanceof ApiError && err.data) {
        console.error('에러 상세:', err.data);
      }
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
        <div className="bg-white rounded-2xl shadow-2xl max-w-2xl w-full p-6">
          <div className="text-center py-8 text-gray-500">로딩 중...</div>
        </div>
      </div>
    );
  }

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-gray-200">
          <h2 className="text-xl font-bold text-gray-900">성분 정보 수정</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <X className="w-5 h-5 text-gray-600" />
          </button>
        </div>

        {/* Content */}
        <div className="px-6 py-6 overflow-y-auto max-h-[calc(90vh-180px)] space-y-4">
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              주요 성분 텍스트 *
            </label>
            <textarea
              value={formData.ingredients_text}
              onChange={(e) => setFormData({ ...formData, ingredients_text: e.target.value })}
              className="admin-input w-full h-32 focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="예: 닭고기, 쌀, 옥수수, 비트펄프, 어유..."
            />
            <p className="text-xs text-gray-500 mt-1">
              상품에 표시된 성분 목록을 입력하세요 (쉼표로 구분)
            </p>
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              첨가제 텍스트
            </label>
            <textarea
              value={formData.additives_text}
              onChange={(e) => setFormData({ ...formData, additives_text: e.target.value })}
              className="admin-input w-full h-24 focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="예: 비타민 A, 비타민 D3, 철..."
            />
            <p className="text-xs text-gray-500 mt-1">
              첨가제 목록을 입력하세요 (선택사항)
            </p>
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              출처
            </label>
            <input
              type="text"
              value={formData.source}
              onChange={(e) => setFormData({ ...formData, source: e.target.value })}
              className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="예: 제품 포장지, 공식 웹사이트..."
            />
            <p className="text-xs text-gray-500 mt-1">
              성분 정보의 출처를 입력하세요 (선택사항)
            </p>
          </div>
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
            disabled={!formData.ingredients_text.trim() || saving}
            className="admin-btn px-6 py-2 bg-blue-500 hover:bg-blue-600 text-white disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {saving ? '저장 중...' : '저장'}
          </button>
        </div>
      </div>
    </div>
  );
}
