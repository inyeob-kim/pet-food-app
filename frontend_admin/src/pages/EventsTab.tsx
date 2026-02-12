import { useState } from 'react';
import { CampaignList } from '../components/events/CampaignList';
import { RewardsList } from '../components/events/RewardsList';
import { ImpressionsList } from '../components/events/ImpressionsList';
import { SimulationPanel } from '../components/events/SimulationPanel';
import { UsageGuide } from '../components/events/UsageGuide';

type SubTab = 'campaigns' | 'rewards' | 'impressions' | 'simulation' | 'guide';

export function EventsTab() {
  const [activeSubTab, setActiveSubTab] = useState<SubTab>('campaigns');

  const subTabs = [
    { id: 'campaigns', label: '캠페인 목록' },
    { id: 'rewards', label: '리워드 조회' },
    { id: 'impressions', label: '노출 조회' },
    { id: 'simulation', label: '시뮬레이션' },
    { id: 'guide', label: '사용 가이드' },
  ];

  return (
    <div>
      {/* Sub Tabs */}
      <div className="flex gap-2 mb-6 border-b border-gray-200">
        {subTabs.map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveSubTab(tab.id as SubTab)}
            className={`px-6 py-3 text-sm font-semibold transition-all border-b-2 ${
              activeSubTab === tab.id
                ? 'border-blue-500 text-blue-600'
                : 'border-transparent text-gray-600 hover:text-gray-900'
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Content */}
      {activeSubTab === 'campaigns' && <CampaignList />}
      {activeSubTab === 'rewards' && <RewardsList />}
      {activeSubTab === 'impressions' && <ImpressionsList />}
      {activeSubTab === 'simulation' && <SimulationPanel />}
      {activeSubTab === 'guide' && <UsageGuide />}
    </div>
  );
}
