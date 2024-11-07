import { createPublicClient, hexToBigInt, http, keccak256, toHex } from 'viem';
import { publicClient } from './client.ts';

const CONTRACT_ADDRESS = '0x21881f38542e30c313b9c5c8e2f8fb4c6abfcbd5';

async function getPrivateLocks() {
    const lockInfos: Array<{ user: string, startTime: bigint, amount: bigint }> = [];

    // 基础槽计算，使用 Keccak256 计算槽
    const initHex = hexToBigInt(keccak256(toHex(0, { size: 32 })));

    const locksLength = await publicClient.getStorageAt({
        address: CONTRACT_ADDRESS,
        slot: toHex(0)
    });

    const length = hexToBigInt(locksLength!);


    for (let i = 0n; i < length; i++) {

        // 计算每个锁定信息的存储槽
        const userAndStartTimeSlot = initHex + i * 2n;
        const amountSlot = userAndStartTimeSlot + 1n;

        // 将槽位值转换为合适的 Hex 格式
        const userAndStartTimeSlotHex = toHex(userAndStartTimeSlot, { size: 32 });
        const amountSlotHex = toHex(amountSlot, { size: 32 });

        // 获取存储中的数据
        const [userAndStartTimeHex, amountHex] = await Promise.all([
            publicClient.getStorageAt({
                address: CONTRACT_ADDRESS,
                slot: userAndStartTimeSlotHex,
            }),
            publicClient.getStorageAt({
                address: CONTRACT_ADDRESS,
                slot: amountSlotHex,
            })
        ]);

        // 提取用户和开始时间
        const userAndStartTimeData = userAndStartTimeHex!.slice(2);
        const startTimeHex = userAndStartTimeData.slice(0, 24);
        const userHex = userAndStartTimeData.slice(24);

        // 转换为对应的数据类型
        const user = `0x${userHex}`;
        const startTime = hexToBigInt(`0x${startTimeHex}`);
        const amount = hexToBigInt(amountHex!);

        lockInfos.push({ user, startTime, amount });
    }

    return lockInfos;
}

async function fetchAllLockInfos() {
    const lockInfo = await getPrivateLocks();
    if (lockInfo) {
        lockInfo.forEach((info, index) => {
            console.log(`Lock #${index}:`, info);
        });
    }
}

fetchAllLockInfos().catch(console.error);
