import { useState } from 'react';
import { Navigation } from './components/Navigation';
import { HeroSection } from './components/HeroSection';
import { ProblemSection } from './components/ProblemSection';
import { SolutionSection } from './components/SolutionSection';
import { RewardSection } from './components/RewardSection';
import { VisionSection } from './components/VisionSection';
import { FinalCTA } from './components/FinalCTA';
import { LaunchCountdownSection } from './components/LaunchCountdownSection';
import { SocialProofSection } from './components/SocialProofSection';
import { FinalReinforcementCTA } from './components/FinalReinforcementCTA';
import { AnalysisSimulationModal } from './components/AnalysisSimulationModal';

export default function App() {
  const [isModalOpen, setIsModalOpen] = useState(false);

  return (
    <div className="min-h-screen bg-white">
      <Navigation />
      <main>
        <HeroSection onOpenModal={() => setIsModalOpen(true)} />
        <ProblemSection />
        <SolutionSection />
        <RewardSection />
        <VisionSection />
        <FinalCTA />
        <LaunchCountdownSection />
        <SocialProofSection />
        <FinalReinforcementCTA />
      </main>
      <AnalysisSimulationModal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
      />
    </div>
  );
}