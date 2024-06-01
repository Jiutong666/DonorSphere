import { HomeCard } from '@/types';

export const homeCardList: HomeCard[] = [
  {
    title: 'Verified projects',
    description: 'Trust that your donations will make an impact with our verification system.',
    buttonLabel: 'HOW IT WORKS',
    icon: 'verified.svg',
  },
  {
    title: 'Donor Rewards',
    description: 'Get rewarded for giving to verified public goods projects.',
    buttonLabel: 'LEARN MORE',
    icon: 'donor_rewards.svg',
  },
  {
    title: 'Easy Onboarding',
    description: `New to crypto? It's easy to get started on DonorSphere.`,
    buttonLabel: 'GET STARTED',
    icon: 'easy_onboarding.svg',
  },
];

export const columns = [
  {
    key: 'donatedAt',
    label: 'Donated at',
  },
  {
    key: 'donor',
    label: 'Donor',
  },
  {
    key: 'amount',
    label: 'Amount',
  },
  {
    key: 'usdValue',
    label: 'USD Value',
  },
];

export const VotingFactoryAddress = '0x8538a10Db0D1567b06bB55174d94668c8841E532';
