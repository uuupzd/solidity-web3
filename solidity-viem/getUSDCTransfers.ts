import { createPublicClient, http, parseAbiItem, formatUnits } from 'viem';
import { mainnet } from 'viem/chains';
import { parseUnits } from 'ethers';

const USDC_ADDRESS = '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48';
const TRANSFER_TOPIC = '0xddf252ad1ee1f3c1013c961e9b9c6f40f2c8b6d4a8a438e7d5d21bb8a44a9b19';
const ETH_MAINNET_RPC_URL = 'https://eth-mainnet.g.alchemy.com/v2/RHGemUJ5PSRgFEdXbX3HWJ9xIMXrfJvS';


const client = createPublicClient({
    chain: mainnet,
    transport: http(ETH_MAINNET_RPC_URL, {
        batch: true,
        retryCount: 3,
        retryDelay: 1000,
    }),
});

async function getUSDCTransfers() {
    const blockNumber = await client.getBlockNumber();
    const fromBlock = blockNumber - BigInt(100); // 最近 100 个区块

    console.log(`当前区块号: ${blockNumber}`);
    console.log(`从区块 ${fromBlock} 到 ${blockNumber} 查询 USDC 交易日志`);

    try {
        // 查询所有 Transfer 事件
        const logs = await client.getLogs({
            address: USDC_ADDRESS,
            fromBlock: fromBlock,
            event: parseAbiItem('event Transfer(address indexed from, address indexed to, uint256 value)'),
            toBlock: "latest",
        });
        console.log('获取到的日志:', logs);

        // const transferLogs = logs.filter(log => log.topics && log.topics[0] === TRANSFER_TOPIC);

        // 处理 Transfer 事件
        logs.forEach(log => {
            const { from, to, value } = log.args || {};
            if (from && to && value !== undefined) {
                const amount = formatUnits(value, 6).toString();
                const transactionHash = log.transactionHash;

                // 输出格式
                console.log(`从 ${from} 转账给 ${to} ${amount} USDC ,交易ID：${transactionHash}`);
            }
        });
    } catch (error) {
        console.error("获取日志时出错:", error);
    }
}
// 执行函数
getUSDCTransfers().catch(console.error);
