import { createPublicClient, http ,parseAbiItem} from 'viem';
import { mainnet } from 'viem/chains';
import { parseUnits } from 'ethers';

const USDC_ADDRESS = '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48';
const TRANSFER_TOPIC = '0xddf252ad1ee1f3c1013c961e9b9c6f40f2c8b6d4a8a438e7d5d21bb8a44a9b19';


const client = createPublicClient({
    chain: mainnet,
    transport: http(),
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
            fromBlock:fromBlock,
            event: parseAbiItem('event Transfer(address indexed from, address indexed to, uint256 value)'),
            toBlock: "latest",
        });
        console.log('获取到的日志:', logs); 

        // 过滤 Transfer 事件
        const transferLogs = logs.filter(log => log.topics && log.topics[0] === TRANSFER_TOPIC);

        for (const log of transferLogs) {
            // 确保 topics 有足够的元素
            if (log.topics && log.topics.length >= 3) {
                const from = `0x${log.topics[1]?.slice(26)}`; // 提取发送者地址
                const to = `0x${log.topics[2]?.slice(26)}`; // 提取接收者地址
                const value = parseUnits(log.data, 6); // 转换为 USDC 单位（USDC 有 6 位小数）
                const transactionHash = log.transactionHash;

                // 输出格式
                console.log(`从 ${from} 转账给 ${to} ${value.toString()} USDC ,交易ID：${transactionHash}`);
            }
        }
    } catch (error) {
        console.error("获取日志时出错:", error);
    }
}
// 执行函数
getUSDCTransfers().catch(console.error);
