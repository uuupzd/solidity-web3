// index.ts
import { createPublicClient, http, parseAbiItem, formatUnits } from 'viem';
import { mainnet } from 'viem/chains';
import { publicClient } from './client.ts';

const USDT_ADDRESS = '0xdac17f958d2ee523a2206206994597c13d831ec7';

async function watchUSDTTransfers() {
    console.log(`开始监听 USDT 转账事件...`);

    try {
        await publicClient.watchEvent({
            address: USDT_ADDRESS,
            event: parseAbiItem('event Transfer(address indexed from, address indexed to, uint256 value)'),
            onLogs: (logs) => {
                logs.forEach((log) => {
                    const { from, to, value } = log.args || {};
                    if (from && to && value !== undefined) {
                        const amount = formatUnits(value, 6).toString(); // USDT 有 6 位小数
                        const transactionHash = log.transactionHash;

                        console.log(`从 ${from} 转账给 ${to} ${amount} USDT , 交易ID：${transactionHash}`);

                        const logElement = document.getElementById('transfer-log');
                        if (logElement) {
                            logElement.innerHTML += `从 ${from} 转账给 ${to} ${amount} USDT , 交易ID：${transactionHash} <br>`;
                        }
                    }
                });
            },
        });
    } catch (error) {
        console.error("监听事件时出错:", error);
    }
}

watchUSDTTransfers().catch(console.error);
