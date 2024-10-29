import { createPublicClient, http } from 'viem';
import { mainnet } from 'viem/chains';

const client = createPublicClient({
    chain: mainnet,
    transport: http(),
});

// 合约地址和 token ID
const contractAddress = '0x0483b0dfc6c78062b9e999a82ffb795925381415';
const tokenId = 1;

async function getNftInfo() {
    try {
        // 读取 NFT 持有者地址
        const owner = await client.readContract({
            address: contractAddress,
            abi: [
                {
                    name: 'ownerOf',
                    type: 'function',
                    inputs: [{ type: 'uint256', name: 'tokenId' }],
                    outputs: [{ type: 'address' }],
                },
            ],
            functionName: 'ownerOf',
            args: [tokenId],
        });

        console.log('Owner Address:', owner);

        // 读取 NFT 元数据
        const tokenURI = await client.readContract({
            address: contractAddress,
            abi: [
                {
                    name: 'tokenURI',
                    type: 'function',
                    inputs: [{ type: 'uint256', name: 'tokenId' }],
                    outputs: [{ type: 'string' }],
                },
            ],
            functionName: 'tokenURI',
            args: [tokenId],
        });

        console.log('Token URI:', tokenURI);
    } catch (error) {
        console.error('Error:', error);
    }
}

getNftInfo();
