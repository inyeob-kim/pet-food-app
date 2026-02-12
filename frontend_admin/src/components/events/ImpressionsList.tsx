import { useState } from 'react';
import { Search } from 'lucide-react';
import { Impression } from '../../data/mockCampaigns';
import { campaignService } from '../../services/campaignService';
import { toast } from 'sonner@2.0.3';
import { ApiError } from '../../config/api';

export function ImpressionsList() {
  const [impressions, setImpressions] = useState<Impression[]>([]);
  const [loading, setLoading] = useState(false);
  const [searchUserId, setSearchUserId] = useState('');
  const [searchCampaignId, setSearchCampaignId] = useState('');

  const loadImpressions = async () => {
    try {
      setLoading(true);
      const params: any = {};
      if (searchUserId) params.user_id = searchUserId;
      if (searchCampaignId) params.campaign_id = searchCampaignId;
      
      const data = await campaignService.getImpressions(params);
      setImpressions(data);
    } catch (err) {
      const errorMessage = err instanceof ApiError 
        ? `API 오류: ${err.status} ${err.statusText}`
        : '노출 조회에 실패했습니다.';
      toast.error(errorMessage);
      console.error('노출 조회 실패:', err);
    } finally {
      setLoading(false);
    }
  };

  const filteredImpressions = impressions.filter((impression: any) =>
    searchUserId === '' || (impression.user_id || impression.userId).includes(searchUserId)
  );

  return (
    <div className="admin-card p-6">
      <h2 className="text-xl font-bold text-gray-900 mb-6">노출 조회</h2>

      {/* Filters */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-3 mb-6">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <input
            type="text"
            placeholder="User ID (UUID)"
            value={searchUserId}
            onChange={(e) => setSearchUserId(e.target.value)}
            className="admin-input w-full pl-10 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <input
            type="text"
            placeholder="Campaign ID (UUID)"
            value={searchCampaignId}
            onChange={(e) => setSearchCampaignId(e.target.value)}
            className="admin-input w-full pl-10 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <button
          onClick={loadImpressions}
          disabled={loading}
          className="admin-btn px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white disabled:opacity-50"
        >
          {loading ? '조회 중...' : '조회'}
        </button>
      </div>

      {/* Table */}
      <div className="border border-gray-200 rounded-xl overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600">User ID</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600">Campaign Key</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600">Seen Count</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600">Last Seen At</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600">Suppress Until</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {filteredImpressions.length === 0 ? (
                <tr>
                  <td colSpan={5} className="px-4 py-8 text-center text-gray-500">
                    {loading ? '조회 중...' : '노출 기록이 없습니다.'}
                  </td>
                </tr>
              ) : (
                filteredImpressions.map((impression: any) => (
                  <tr key={impression.id || `${impression.user_id}-${impression.campaign_key}`} className="hover:bg-gray-50">
                    <td className="px-4 py-3">
                      <code className="text-sm font-mono text-gray-700">{impression.user_id || impression.userId}</code>
                    </td>
                    <td className="px-4 py-3">
                      <code className="text-sm font-mono text-blue-600">{impression.campaign_key || impression.campaignId}</code>
                    </td>
                    <td className="px-4 py-3">
                      <span className="font-semibold text-gray-900">{impression.seen_count || impression.seenCount}회</span>
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-600">
                      {new Date(impression.last_seen_at || impression.lastSeenAt).toLocaleString('ko-KR')}
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-600">
                      {impression.suppress_until || impression.suppressUntil
                        ? new Date(impression.suppress_until || impression.suppressUntil).toLocaleString('ko-KR')
                        : '-'}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      <div className="mt-4 text-sm text-gray-600">
        총 {filteredImpressions.length}개 노출 기록
      </div>
    </div>
  );
}
