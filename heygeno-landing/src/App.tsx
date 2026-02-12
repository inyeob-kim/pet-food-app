import { useState } from 'react';
import { LanguageProvider } from './contexts/LanguageContext';
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
import { PriceAlertModal } from './components/PriceAlertModal';

export default function App() {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isPriceModalOpen, setIsPriceModalOpen] = useState(false);

  const handleOpenAnalysisModal = () => {
    console.log('🔵 Opening ANALYSIS modal');
    setIsModalOpen(true);
  };

  const handleOpenPriceModal = () => {
    console.log('🟢 Opening PRICE modal');
    setIsPriceModalOpen(true);
  };

  const handleCloseAnalysisModal = () => {
    console.log('🔴 Closing ANALYSIS modal');
    setIsModalOpen(false);
  };

  const handleClosePriceModal = () => {
    console.log('🟠 Closing PRICE modal');
    setIsPriceModalOpen(false);
  };

  console.log('App state - Analysis:', isModalOpen, 'Price:', isPriceModalOpen);

  return (
    <LanguageProvider>
      <div className="min-h-screen bg-white">
        <Navigation />
        <main className="w-full overflow-x-hidden">
          <HeroSection 
            onOpenModal={handleOpenAnalysisModal} 
            onOpenPriceModal={handleOpenPriceModal}
          />
          <ProblemSection />
          <SolutionSection 
            onOpenModal={handleOpenAnalysisModal}
            onOpenPriceModal={handleOpenPriceModal}
          />
          <RewardSection />
          <VisionSection />
          <FinalCTA />
          <LaunchCountdownSection />
          <SocialProofSection />
          <FinalReinforcementCTA />
        </main>
        <AnalysisSimulationModal 
          isOpen={isModalOpen} 
          onClose={handleCloseAnalysisModal} 
        />
        <PriceAlertModal 
          isOpen={isPriceModalOpen} 
          onClose={handleClosePriceModal} 
        />
      </div>
    </LanguageProvider>
  );
}