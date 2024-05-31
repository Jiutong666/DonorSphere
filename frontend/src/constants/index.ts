import { DonateTable, HomeCard, ProjectInfo } from '@/types';

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

export const testProjectInfo: ProjectInfo[] = [
  {
    id: '1',
    name: 'TEST 1',
    description:
      'Greetings! I‘m thrilled to share the exciting initiative, where I aim to unite digital and local communities through the magic of music',
    picture: 'https://nextui-docs-v2.vercel.app/images/hero-card-complete.jpeg',
    founder: 'Shawbit',
    targetAmount: '1111.33',
    raisedAmount: '3889',
    beneficiary: '0x000003kdkkfg',
  },
];

export const rows: DonateTable[] = [
  {
    key: '1',
    donatedAt: '2022/22/02',
    donor: '333',
    amount: '5555',
    usdValue: '22222',
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

export const VotingBaseAddress = '0x8538a10Db0D1567b06bB55174d94668c8841E532';
