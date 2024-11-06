// index.ts
import { createPublicClient, http, parseAbiItem, toHex } from 'viem';
import { publicClient } from './client.ts';

const CONTRACT_ADDRESS = '0x21881f38542e30c313b9c5c8e2f8fb4c6abfcbd5';

async function getPrivateLocks() {
    const data = await publicClient.getStorageAt({
        address: CONTRACT_ADDRESS,
        slot: toHex(0)
    })

    console.log("data:",data)

}

getPrivateLocks().catch(console.error);
