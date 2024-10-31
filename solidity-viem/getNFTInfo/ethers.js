const { Wallet } = require('ethers');

const privateKey = 'ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'; 
const wallet = new Wallet(privateKey);

console.log('公钥:', wallet.publicKey);
console.log('地址:', wallet.address);

const text1 = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";
const text2 = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";


if (text1 === text2) {
    console.log("text1 和 text3 是相等的");
} else {
    console.log("text1 和 text3 不是相等的");
}