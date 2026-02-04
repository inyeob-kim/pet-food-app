import { AppBar } from '../components/AppBar';
import { ChevronRight, Bell, Lock, HelpCircle, LogOut } from 'lucide-react';
import { petData } from '../data/mockData';

export function MyScreen() {
  const settings = [
    { icon: Bell, label: 'Notifications', value: 'On', hasToggle: true },
    { icon: Lock, label: 'Privacy', hasChevron: true },
    { icon: HelpCircle, label: 'Help & Support', hasChevron: true },
  ];

  return (
    <div className="pb-6">
      <AppBar title="My" />
      
      <div className="px-4 space-y-8">
        {/* Health Summary Pill */}
        <div className="pt-6">
          <div className="p-4 rounded-2xl bg-[#F0FDF4] border border-[#16A34A]/20">
            <div className="flex items-center gap-3 mb-3">
              <div className="text-4xl">🐕</div>
              <div className="flex-1">
                <h3 className="text-body text-[#111827] mb-1">{petData.name}</h3>
                <p className="text-sub text-[#6B7280]">
                  {petData.breed}, {petData.age} years
                </p>
              </div>
              <div className="w-12 h-12 rounded-full bg-[#16A34A]/10 flex items-center justify-center">
                <div className="text-body text-[#16A34A] font-semibold">BCS {petData.bcs}</div>
              </div>
            </div>
            <div className="flex items-center gap-2">
              <div className="flex-1 h-2 bg-[#16A34A]/20 rounded-full overflow-hidden">
                <div className="h-full bg-[#16A34A] rounded-full" style={{ width: '60%' }} />
              </div>
              <span className="text-sub text-[#16A34A] font-medium">Healthy</span>
            </div>
          </div>
        </div>

        {/* Profile Info List */}
        <div>
          <h3 className="text-body text-[#111827] mb-4">Profile Information</h3>
          <div className="space-y-3">
            <div className="flex items-center justify-between p-4 rounded-2xl bg-[#F7F8FA]">
              <span className="text-body text-[#6B7280]">Weight</span>
              <span className="text-body text-[#111827] font-semibold">{petData.weight}kg</span>
            </div>
            <div className="flex items-center justify-between p-4 rounded-2xl bg-[#F7F8FA]">
              <span className="text-body text-[#6B7280]">Age</span>
              <span className="text-body text-[#111827] font-semibold">{petData.age} years</span>
            </div>
            <div className="flex items-center justify-between p-4 rounded-2xl bg-[#F7F8FA]">
              <span className="text-body text-[#6B7280]">Breed</span>
              <span className="text-body text-[#111827] font-semibold">{petData.breed}</span>
            </div>
          </div>
        </div>

        {/* Notification Settings */}
        <div>
          <h3 className="text-body text-[#111827] mb-4">Settings</h3>
          <div className="space-y-1">
            {settings.map((setting) => {
              const Icon = setting.icon;
              return (
                <button
                  key={setting.label}
                  className="w-full flex items-center gap-3 p-4 hover:bg-[#F7F8FA] rounded-2xl transition-all active:scale-[0.98]"
                >
                  <Icon className="w-5 h-5 text-[#6B7280]" />
                  <span className="flex-1 text-left text-body text-[#111827]">{setting.label}</span>
                  {setting.value && (
                    <span className="text-body text-[#6B7280]">{setting.value}</span>
                  )}
                  {setting.hasToggle && (
                    <div className="w-11 h-6 rounded-full bg-[#2563EB] relative">
                      <div className="absolute right-1 top-1 w-4 h-4 rounded-full bg-white" />
                    </div>
                  )}
                  {setting.hasChevron && (
                    <ChevronRight className="w-5 h-5 text-[#6B7280]" />
                  )}
                </button>
              );
            })}
          </div>
        </div>

        {/* Point Summary Section */}
        <div className="p-4 rounded-2xl bg-gradient-to-br from-[#EFF6FF] to-[#F7F8FA]">
          <div className="flex items-center justify-between mb-2">
            <span className="text-body text-[#111827]">Available Points</span>
            <span className="text-price text-[#2563EB]">1,850</span>
          </div>
          <p className="text-sub text-[#6B7280] mb-4">
            Use points for discounts on your next purchase
          </p>
          <button className="h-9 px-4 rounded-xl bg-[#2563EB] text-white text-sub hover:bg-[#1d4ed8] active:scale-95 transition-all">
            View benefits
          </button>
        </div>

        {/* Logout */}
        <button className="w-full flex items-center justify-center gap-2 p-4 text-body text-[#EF4444] hover:bg-[#FEF2F2] rounded-2xl transition-all active:scale-[0.98]">
          <LogOut className="w-5 h-5" />
          <span>Log out</span>
        </button>
      </div>
    </div>
  );
}
