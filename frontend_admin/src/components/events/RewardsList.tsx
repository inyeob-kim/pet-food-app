import { useState, useEffect } from 'react';
import { Search } from 'lucide-react';
import { Reward } from '../../data/mockCampaigns';
import { campaignService } from '../../services/campaignService';
import { toast } from 'sonner@2.0.3';
import { ApiError } from '../../config/api';

export function RewardsList() {
  const [rewards, setRewards] = useState<Reward[]>([]);
  const [loading, setLoading] = useState(false);
  const [searchUserId, setSearchUserId] = useState('');
  const [searchCampaignId, setSearchCampaignId] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('ALL');

  const loadRewards = async () => {
    try {
      setLoading(true);
      const params: any = {};
      if (searchUserId) params.user_id = searchUserId;
      if (searchCampaignId) params.campaign_id = searchCampaignId;
      
      const data = await campaignService.getRewards(params);
      setRewards(data);
    } catch (err) {
      const errorMessage = err instanceof ApiError 
        ? `API 오류: ${err.status} ${err.statusText}`
        : '리워드 조회에 실패했습니다.';
      toast.error(errorMessage);
      console.error('리워드 조회 실패:', err);
    } finally {
      setLoading(false);
    }
  };

  const filteredRewards = rewards.filter((reward) => {
    const matchesUser =
      searchUserId === '' || reward.userId.includes(searchUserId);
    const matchesCampaign =
      searchCampaignId === '' || reward.campaignId.includes(searchCampaignId);
    const matchesStatus = statusFilter === 'ALL' || reward.status === statusFilter;
    return matchesUser && matchesCampaign && matchesStatus;
  });

  return (
    <div className="admin-card p-6">
      <h2 className="text-xl font-bold text-gray-900 mb-6">리워드 조회</h2>

      {/* Filters */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-3 mb-6">
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

        <select
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
          className="admin-input focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          <option value="ALL">전체 상태</option>
          <option value="GRANTED">지급완료</option>
          <option value="PENDING">대기중</option>
          <option value="FAILED">실패</option>
        </select>

        <button
          onClick={loadRewards}
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
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600">상태</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600">지급일</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600">Idempotency Key</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {filteredRewards.length === 0 ? (
                <tr>
                  <td colSpan={5} className="px-4 py-8 text-center text-gray-500">
                    {loading ? '조회 중...' : '리워드 내역이 없습니다.'}
                  </td>
                </tr>
              ) : (
                filteredRewards.map((reward: any) => (
                  <tr key={reward.id || `${reward.user_id}-${reward.campaign_key}`} className="hover:bg-gray-50">
                    <td className="px-4 py-3">
                      <code className="text-sm font-mono text-gray-700">{reward.user_id || reward.userId}</code>
                    </td>
                    <td className="px-4 py-3">
                      <code className="text-sm font-mono text-blue-600">{reward.campaign_key || reward.campaignId}</code>
                    </td>
                    <td className="px-4 py-3">
                      <span
                        className={`px-2 py-1 rounded-full text-xs font-semibold ${
                          reward.status === 'GRANTED'
                            ? 'bg-green-100 text-green-700'
                            : reward.status === 'PENDING'
                            ? 'bg-yellow-100 text-yellow-700'
                            : 'bg-red-100 text-red-700'
                        }`}
                      >
                        {reward.status === 'GRANTED'
                          ? '지급완료'
                          : reward.status === 'PENDING'
                          ? '대기중'
                          : '실패'}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-600">
                      {reward.granted_at ? new Date(reward.granted_at).toLocaleString('ko-KR') : '-'}
                    </td>
                    <td className="px-4 py-3">
                      <code className="text-xs font-mono text-gray-500">
                        {reward.idempotency_key || '-'}
                      </code>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      <div className="mt-4 text-sm text-gray-600">
        총 {filteredRewards.length}개 리워드
      </div>
    </div>
  );
}
