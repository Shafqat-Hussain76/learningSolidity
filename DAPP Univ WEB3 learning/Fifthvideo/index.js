require('dotenv').config();

const Web3 = require('web3');
const rpcurl = 'https://ropsten.infura.io/v3/22e41a0082b44d1e9e920225f861bcdf';
const web3 = new Web3(rpcurl);

const Tx = require('ethereumjs-tx').Transaction;

const acc1 = '0x29B574ddAD30F1b5EB8907f2BC04bBf61761c1a2';
const acc1prvkey = Buffer.from(process.env.acc1_pvt_key, 'hex');
const acc2 = '0xFE2c44CB675bA74336DB483a6479830dD453Cd1f';

const contractAddress = '0x49EfD124C83DecB845D04b97631003c63a49568b';
const contractABI = [{"inputs":[{"internalType":"uint256","name":"_initialSupply","type":"uint256"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Transfer","type":"event"},{"stateMutability":"payable","type":"fallback"},{"inputs":[{"internalType":"uint256","name":"newPrice","type":"uint256"}],"name":"adjustTokenPrice","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"recepint","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"purchaseTokens","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"recepint","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"stateMutability":"payable","type":"receive"}]

//const contractABIHex = Buffer.from(contractABI, 'hex');
const contract = new web3.eth.Contract(contractABI, contractAddress);

const funcmethodcontract = async () => {
    try {
        const TxCount = await web3.eth.getTransactionCount(acc1);
        txObject = {
            nonce: web3.utils.toHex(TxCount),
            gasPrice: web3.utils.toHex(web3.utils.toWei('10', 'gWei')),
            gasLimit: web3.utils.toHex(2000000),
            data: contract.methods.transfer(acc2, 50).encodeABI(),
            to: contractAddress
        }
        const tx = new Tx(txObject, { 'chain':'ropsten' });
        tx.sign(acc1prvkey);
        const TXSERIALIZE = tx.serialize();
        const raw = '0x' + TXSERIALIZE.toString('hex');

        const response = await web3.eth.sendSignedTransaction(raw);
        console.log(response);

    } catch(err) {
        console.log(err);
    }
}
funcmethodcontract();