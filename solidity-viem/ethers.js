import { encodeFunctionData, decodeFunctionResult } from 'viem';

// 编码函数调用数据
const data = encodeFunctionData({
  name: 'transfer',
  type: 'function',
  inputs: [{ type: 'address', name: 'to' }, { type: 'uint256', name: 'value' }]
}, ['0xaddress', '1000']);

// 解码函数返回数据
const decoded = decodeFunctionResult({
  name: 'transfer',
  type: 'function',
  outputs: [{ type: 'bool' }]
}, '0xdata');
console.log(decoded);
