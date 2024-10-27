import { namehash } from "viem";
import {hashMessage} from "viem";
import {privateKeyToAccount} from "viem/accounts";

const message = "Hello World!";
const privateKey = "0x4c27dxxxx";

const messageHash = hashMessage(message);
console.log("Message Hash1:",messageHash);


const account = privateKeyToAccount(privateKey);
console.log("address:",account);

const signature = await account.signMessage({messageHash})
console.log("Signature:",signature)