import { http, stringify } from 'viem';
import { mainnet } from 'viem/chains';
import { publicClient } from './client.js';

publicClient.watchBlockNumber({
    onBlockNumber: (blockNumber) => {
        document.getElementById('block-number')!.innerHTML =
            `Block number: ${blockNumber}`
    },
})

publicClient.watchBlocks({
    onBlock: (block) => {
        document.getElementById('block')!.innerHTML =
            `Block: <pre><code>${stringify(block, null, 2)}</code></pre>`
    },
})

//npm run dev

