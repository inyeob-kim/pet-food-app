import { useState, useEffect } from 'react';
import { X } from 'lucide-react';
import { Product } from '../../data/mockProducts';
import { productService } from '../../services/productService';
import { ApiError } from '../../config/api';
import { toast } from 'sonner@2.0.3';

interface EditNutritionDialogProps {
  product: Product;
  onClose: () => void;
  onSave: () => void;
}

export function EditNutritionDialog({ product, onClose, onSave }: EditNutritionDialogProps) {
  const [formData, setFormData] = useState({
    protein_pct: '',
    fat_pct: '',
    fiber_pct: '',
    moisture_pct: '',
    ash_pct: '',
    kcal_per_100g: '',
    calcium_pct: '',
    phosphorus_pct: '',
    aafco_statement: '',
  });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    loadNutritionData();
  }, []);

  const loadNutritionData = async () => {
    try {
      setLoading(true);
      const data = await productService.getNutrition(product.id);
      if (data) {
        setFormData({
          protein_pct: data.protein_pct?.toString() || '',
          fat_pct: data.fat_pct?.toString() || '',
          fiber_pct: data.fiber_pct?.toString() || '',
          moisture_pct: data.moisture_pct?.toString() || '',
          ash_pct: data.ash_pct?.toString() || '',
          kcal_per_100g: data.kcal_per_100g?.toString() || '',
          calcium_pct: data.calcium_pct?.toString() || '',
          phosphorus_pct: data.phosphorus_pct?.toString() || '',
          aafco_statement: data.aafco_statement || '',
        });
      }
    } catch (err) {
      // 영양 정보가 없을 수 있음
      console.log('영양 정보 없음');
    } finally {
      setLoading(false);
    }
  };

  const handleSave = async () => {
    try {
      setSaving(true);
      const updateData: any = {};
      
      // 숫자 필드 처리: 빈 문자열이거나 NaN이면 null로 설정
      const parseFloatOrNull = (value: string): number | null => {
        if (!value || value.trim() === '') return null;
        const parsed = parseFloat(value);
        return isNaN(parsed) ? null : parsed;
      };
      
      const parseIntOrNull = (value: string): number | null => {
        if (!value || value.trim() === '') return null;
        const parsed = parseInt(value, 10);
        return isNaN(parsed) ? null : parsed;
      };
      
      // 값이 있으면 추가 (null이 아닌 경우만)
      const protein = parseFloatOrNull(formData.protein_pct);
      if (protein !== null) updateData.protein_pct = protein;
      
      const fat = parseFloatOrNull(formData.fat_pct);
      if (fat !== null) updateData.fat_pct = fat;
      
      const fiber = parseFloatOrNull(formData.fiber_pct);
      if (fiber !== null) updateData.fiber_pct = fiber;
      
      const moisture = parseFloatOrNull(formData.moisture_pct);
      if (moisture !== null) updateData.moisture_pct = moisture;
      
      const ash = parseFloatOrNull(formData.ash_pct);
      if (ash !== null) updateData.ash_pct = ash;
      
      const kcal = parseIntOrNull(formData.kcal_per_100g);
      if (kcal !== null) updateData.kcal_per_100g = kcal;
      
      const calcium = parseFloatOrNull(formData.calcium_pct);
      if (calcium !== null) updateData.calcium_pct = calcium;
      
      const phosphorus = parseFloatOrNull(formData.phosphorus_pct);
      if (phosphorus !== null) updateData.phosphorus_pct = phosphorus;
      
      // AAFCO 성명은 빈 문자열이 아니면 추가
      if (formData.aafco_statement && formData.aafco_statement.trim()) {
        updateData.aafco_statement = formData.aafco_statement.trim();
      }

      // 최소 하나의 필드는 입력되어야 함
      if (Object.keys(updateData).length === 0) {
        toast.error('최소 하나의 영양 정보를 입력해주세요.');
        return;
      }

      await productService.updateNutrition(product.id, updateData);
      toast.success('영양 정보가 저장되었습니다.');
      onSave();
      onClose();
    } catch (err) {
      const errorMessage = err instanceof ApiError 
        ? `저장 실패: ${err.status} ${err.statusText}`
        : '영양 정보 저장에 실패했습니다.';
      toast.error(errorMessage);
      console.error('영양 정보 저장 실패:', err);
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
          <h2 className="text-xl font-bold text-gray-900">영양 정보 수정</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <X className="w-5 h-5 text-gray-600" />
          </button>
        </div>

        {/* Content */}
        <div className="px-6 py-6 overflow-y-auto max-h-[calc(90vh-180px)]">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                단백질 (%)
              </label>
              <input
                type="number"
                step="0.1"
                value={formData.protein_pct}
                onChange={(e) => setFormData({ ...formData, protein_pct: e.target.value })}
                className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="0.0"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                지방 (%)
              </label>
              <input
                type="number"
                step="0.1"
                value={formData.fat_pct}
                onChange={(e) => setFormData({ ...formData, fat_pct: e.target.value })}
                className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="0.0"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                섬유질 (%)
              </label>
              <input
                type="number"
                step="0.1"
                value={formData.fiber_pct}
                onChange={(e) => setFormData({ ...formData, fiber_pct: e.target.value })}
                className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="0.0"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                수분 (%)
              </label>
              <input
                type="number"
                step="0.1"
                value={formData.moisture_pct}
                onChange={(e) => setFormData({ ...formData, moisture_pct: e.target.value })}
                className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="0.0"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                회분 (%)
              </label>
              <input
                type="number"
                step="0.1"
                value={formData.ash_pct}
                onChange={(e) => setFormData({ ...formData, ash_pct: e.target.value })}
                className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="0.0"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                칼로리 (kcal/100g)
              </label>
              <input
                type="number"
                value={formData.kcal_per_100g}
                onChange={(e) => setFormData({ ...formData, kcal_per_100g: e.target.value })}
                className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="0"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                칼슘 (%)
              </label>
              <input
                type="number"
                step="0.01"
                value={formData.calcium_pct}
                onChange={(e) => setFormData({ ...formData, calcium_pct: e.target.value })}
                className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="0.00"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                인 (%)
              </label>
              <input
                type="number"
                step="0.01"
                value={formData.phosphorus_pct}
                onChange={(e) => setFormData({ ...formData, phosphorus_pct: e.target.value })}
                className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="0.00"
              />
            </div>
          </div>

          <div className="mt-4">
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              AAFCO 성명
            </label>
            <textarea
              value={formData.aafco_statement}
              onChange={(e) => setFormData({ ...formData, aafco_statement: e.target.value })}
              className="admin-input w-full h-24 focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="예: AAFCO 기준 성장기 강아지 영양 요구량을 충족..."
            />
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
            disabled={saving}
            className="admin-btn px-6 py-2 bg-blue-500 hover:bg-blue-600 text-white disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {saving ? '저장 중...' : '저장'}
          </button>
        </div>
      </div>
    </div>
  );
}
