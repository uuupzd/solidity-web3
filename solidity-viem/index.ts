import { createPublicClient, http } from 'viem';
import { mainnet } from 'viem/chains';

const client = createPublicClient({
    chain: mainnet,
    transport: http(),
});

async function getBlockNumber() {
    const blockNumber = await client.getBlockNumber();
    console.log(`当前区块号: ${blockNumber}`);
}

getBlockNumber().catch(console.error);
