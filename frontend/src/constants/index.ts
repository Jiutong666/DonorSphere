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

export const VotingFactoryAddress = '0x609B3ded277BcB642bFC36b9452Cfc859a75c3C1';
export const VotingBaseAddress = '0xaF7f5a00C1E57f8Db7111272FAe001E3081c9934';
