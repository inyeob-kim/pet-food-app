import { AppBar } from '../components/AppBar';
import { PrimaryButton } from '../components/PrimaryButton';
import { Gift, CheckCircle } from 'lucide-react';

export function BenefitsScreen() {
  const missions = [
    { id: 1, title: 'Watch 3 products', reward: 100, completed: true, current: 3, total: 3 },
    { id: 2, title: 'Complete profile', reward: 200, completed: true, current: 1, total: 1 },
    { id: 3, title: 'Share with a friend', reward: 500, completed: false, current: 0, total: 1 },
    { id: 4, title: 'Write a review', reward: 300, completed: false, current: 0, total: 1 },
    { id: 5, title: 'Make first purchase', reward: 1000, completed: false, current: 0, total: 1 },
  ];

  const totalPoints = 1850;
  const earnedPoints = missions.filter(m => m.completed).reduce((sum, m) => sum + m.reward, 0);

  return (
    <div className="pb-6">
      <AppBar title="Benefits" />
      
      <div className="px-4 space-y-8">
        {/* Hero Point Section */}
        <div className="pt-6">
          <div className="flex items-center gap-2 mb-3">
            <Gift className="w-6 h-6 text-[#2563EB]" />
            <p className="text-body text-[#6B7280]">Your points</p>
          </div>
          <div className="text-hero text-[#2563EB] mb-2">{totalPoints.toLocaleString()}</div>
          <p className="text-body text-[#6B7280]">
            Earn {(missions.reduce((sum, m) => sum + m.reward, 0) - earnedPoints).toLocaleString()} more points available
          </p>
        </div>

        {/* Mission List */}
        <div>
          <h3 className="text-body text-[#111827] mb-4">Complete missions to earn points</h3>
          
          <div className="space-y-3">
            {missions.map((mission) => (
              <div
                key={mission.id}
                className={`p-4 rounded-2xl transition-all ${
                  mission.completed 
                    ? 'bg-[#F0FDF4] border border-[#16A34A]/20' 
                    : 'bg-[#F7F8FA]'
                }`}
              >
                <div className="flex items-start justify-between mb-3">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <h4 className={`text-body ${
                        mission.completed ? 'text-[#6B7280] line-through' : 'text-[#111827]'
                      }`}>
                        {mission.title}
                      </h4>
                      {mission.completed && (
                        <CheckCircle className="w-5 h-5 text-[#16A34A]" />
                      )}
                    </div>
                    <p className="text-sub text-[#6B7280]">
                      {mission.current}/{mission.total} completed
                    </p>
                  </div>
                  <div className="text-right">
                    <div className={`text-body font-semibold ${
                      mission.completed ? 'text-[#16A34A]' : 'text-[#2563EB]'
                    }`}>
                      +{mission.reward}
                    </div>
                    <div className="text-sub text-[#6B7280]">points</div>
                  </div>
                </div>

                {!mission.completed && (
                  <PrimaryButton variant="small" onClick={() => {}}>
                    Start mission
                  </PrimaryButton>
                )}
              </div>
            ))}
          </div>
        </div>

        {/* Points Usage */}
        <div className="p-4 rounded-2xl bg-[#EFF6FF]">
          <h3 className="text-body text-[#111827] mb-2">How to use points</h3>
          <p className="text-sub text-[#6B7280]">
            100 points = 100원 discount on your next purchase
          </p>
        </div>
      </div>
    </div>
  );
}
