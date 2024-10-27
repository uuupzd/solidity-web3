const domain = {
    name: "MyDApp",
    version: "1",
    chainId: 1, // Ethereum Mainnet
    verifyingContract: "0xYourContractAddress",
};

const types = {
    Person: [
        { name: "name", type: "string" },
        { name: "age", type: "uint256" },
    ],
};

const value = {
    name: "Alice",
    age: 30,
};

// 签名数据
const signature = await signer._signTypedData(domain, types, value);
