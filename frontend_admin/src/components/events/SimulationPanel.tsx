import { useState } from 'react';
import { Play, CheckCircle2 } from 'lucide-react';
import { toast } from 'sonner@2.0.3';
import { campaignService } from '../../services/campaignService';
import { ApiError } from '../../config/api';

interface SimulationResult {
  campaignKey: string;
  reason: string;
  priority: number;
  status: string;
}

export function SimulationPanel() {
  const [userId, setUserId] = useState('');
  const [trigger, setTrigger] = useState<'FIRST_TRACKING_CREATED' | 'SIGNUP_COMPLETE' | 'ALERT_CLICKED' | 'REFERRAL_CONFIRMED'>('FIRST_TRACKING_CREATED');
  const [contextJson, setContextJson] = useState('{\n  "pet_type": "DOG",\n  "locale": "ko"\n}');
  const [results, setResults] = useState<any>(null);
  const [isRunning, setIsRunning] = useState(false);

  const handleRunSimulation = async () => {
    if (!userId.trim()) {
      toast.error('User ID를 입력하세요.');
      return;
    }

    setIsRunning(true);
    toast.info('시뮬레이션 실행중...');

    try {
      let context = {};
      if (contextJson.trim()) {
        try {
          context = JSON.parse(contextJson);
        } catch (e) {
          toast.error('Context JSON 형식이 올바르지 않습니다.');
          setIsRunning(false);
          return;
        }
      }

      const result = await campaignService.simulate({
        user_id: userId,
        trigger,
        context,
      });

      setResults(result);
      toast.success('시뮬레이션 완료!');
    } catch (err) {
      const errorMessage = err instanceof ApiError 
        ? `시뮬레이션 실패: ${err.status} ${err.statusText}`
        : '시뮬레이션 실행에 실패했습니다.';
      toast.error(errorMessage);
      console.error('시뮬레이션 실패:', err);
    } finally {
      setIsRunning(false);
    }
  };

  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
      {/* Left: Input */}
      <div className="admin-card p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-6">시뮬레이션 입력</h2>

        <div className="space-y-4">
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              User ID *
            </label>
            <input
              type="text"
              value={userId}
              onChange={(e) => setUserId(e.target.value)}
              className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="user_12345"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Trigger *
            </label>
            <select
              value={trigger}
              onChange={(e) => setTrigger(e.target.value as any)}
              className="admin-input w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="FIRST_TRACKING_CREATED">FIRST_TRACKING_CREATED</option>
              <option value="SIGNUP_COMPLETE">SIGNUP_COMPLETE</option>
              <option value="ALERT_CLICKED">ALERT_CLICKED</option>
              <option value="REFERRAL_CONFIRMED">REFERRAL_CONFIRMED</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Context (JSON)
            </label>
            <textarea
              value={contextJson}
              onChange={(e) => setContextJson(e.target.value)}
              className="admin-input w-full h-32 font-mono text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <button
            onClick={handleRunSimulation}
            disabled={isRunning}
            className="admin-btn w-full px-4 py-3 bg-gradient-to-r from-blue-500 to-cyan-500 hover:from-blue-600 hover:to-cyan-600 text-white flex items-center justify-center gap-2 disabled:opacity-50"
          >
            <Play className="w-5 h-5" />
            {isRunning ? '실행 중...' : '시뮬레이션 실행'}
          </button>
        </div>
      </div>

      {/* Right: Results */}
      <div className="admin-card p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-6">시뮬레이션 결과</h2>

        {!results ? (
          <div className="flex flex-col items-center justify-center h-64 text-center">
            <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-4">
              <span className="text-2xl">🧪</span>
            </div>
            <p className="text-sm text-gray-500">
              왼쪽에서 시뮬레이션을 실행하세요
            </p>
          </div>
        ) : (
          <div className="space-y-4">
            <div className="text-sm text-gray-600 mb-4">
              적용 가능한 캠페인: {results.eligible_campaigns?.length || 0}개
            </div>

            {results.eligible_campaigns?.map((campaign: any, idx: number) => (
              <div key={idx} className="border border-gray-200 rounded-xl p-4">
                <div className="flex items-start gap-3">
                  <div className="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center flex-shrink-0">
                    <CheckCircle2 className="w-5 h-5 text-green-600" />
                  </div>
                  <div className="flex-1">
                    <code className="text-sm font-mono text-blue-600 font-semibold">
                      {campaign.key || campaign.campaign_key}
                    </code>
                    <p className="text-sm text-gray-600 mt-1">
                      {campaign.reason || '조건을 만족하는 캠페인'}
                    </p>
                    <div className="flex items-center gap-3 mt-2">
                      <span className="text-xs text-gray-500">
                        Priority: <span className="font-semibold">{campaign.priority || '-'}</span>
                      </span>
                      {campaign.action && (
                        <span className="px-2 py-0.5 bg-purple-100 text-purple-700 rounded-full text-xs font-semibold">
                          {campaign.action.action_type || 'ACTION'}
                        </span>
                      )}
                    </div>
                  </div>
                </div>
              </div>
            )) || (
              <div className="text-sm text-gray-500 text-center py-8">
                적용 가능한 캠페인이 없습니다.
              </div>
            )}

            {/* Debug Section */}
            <div className="border-t border-gray-200 pt-4 mt-4">
              <details className="cursor-pointer">
                <summary className="text-sm font-semibold text-gray-700 hover:text-gray-900">
                  전체 결과 보기 (JSON)
                </summary>
                <pre className="mt-3 bg-gray-900 text-green-400 p-4 rounded-lg text-xs font-mono overflow-x-auto">
                  {JSON.stringify(results, null, 2)}
                </pre>
              </details>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
