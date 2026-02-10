import { useState, useEffect } from 'react';
import { Navigation } from './Navigation';
import { HeroSection } from './HeroSection';
import { FeatureCards } from './FeatureCards';
import { MultiPlatformSection } from './MultiPlatformSection';
import { RecommendationCriteria } from './RecommendationCriteria';
import { PointsTable } from './PointsTable';
import { BenefitsUsage } from './BenefitsUsage';
import { TrustSection } from './TrustSection';
import { SocialProof } from './SocialProof';
import { EmailSignup } from './EmailSignup';
import { Footer } from './Footer';

export function LandingPage() {
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 20);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <div className="min-h-screen bg-white text-gray-900 overflow-x-hidden">
      <Navigation scrolled={scrolled} />
      <HeroSection />
      <FeatureCards />
      <MultiPlatformSection />
      <RecommendationCriteria />
      <PointsTable />
      <BenefitsUsage />
      <TrustSection />
      <SocialProof />
      <EmailSignup />
      <Footer />
    </div>
  );
}