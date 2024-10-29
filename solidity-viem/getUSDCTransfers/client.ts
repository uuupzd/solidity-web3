import { createPublicClient, http } from 'viem'
import { mainnet } from 'viem/chains'

const ETH_MAINNET_RPC_URL = 'https://eth-mainnet.g.alchemy.com/v2/RHGemUJ5PSRgFEdXbX3HWJ9xIMXrfJvS';

export const publicClient = createPublicClient({
  chain: mainnet,
  transport: http(ETH_MAINNET_RPC_URL, {
    batch: true,
    retryCount: 3,
    retryDelay: 1000,
  })
})