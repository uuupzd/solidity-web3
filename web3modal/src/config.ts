// src/config.ts
import { createWeb3Modal, defaultWagmiConfig } from '@web3modal/wagmi';
import { mainnet, arbitrum } from 'viem/chains';
import { reconnect } from '@wagmi/core';

const projectId = '5854b5214eff98a7d7a0bc465079d6e4'; 

const metadata = {
  name: 'Web3Modal',
  description: 'Web3Modal Tzhaoo',
  url: 'https://web3modal.com',
  icons: ['https://avatars.githubusercontent.com/u/37784886']
};

const chains = [mainnet, arbitrum] as const;

export const config = defaultWagmiConfig({
  chains,
  projectId,
  metadata,
});
reconnect(config);

export const modal = createWeb3Modal({
  wagmiConfig: config,
  projectId,
});
