import { connectorsForWallets } from '@rainbow-me/rainbowkit';
import { metaMaskWallet, okxWallet } from '@rainbow-me/rainbowkit/wallets';
import { createConfig, http } from 'wagmi';
import { sepolia } from 'wagmi/chains';

const connectors = connectorsForWallets(
  [
    {
      groupName: 'Recommended',
      wallets: [metaMaskWallet, okxWallet],
    },
  ],
  {
    appName: 'DonorSphere',
    projectId: '2d6a25974b42d074a31a940847def6e3',
  }
);

export const config = createConfig({
  connectors,
  chains: [sepolia],
  transports: {
    [sepolia.id]: http('https://eth-sepolia.g.alchemy.com/v2/57WJ6OLUOS_IPM2-4W6FTVXbyjGBQii6'),
  },
  ssr: true,
});
