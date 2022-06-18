const Web3 = require('web3');
const rpcurl = 'https://ropsten.infura.io/v3/22e41a0082b44d1e9e920225f861bcdf';
const web3 = new Web3(rpcurl);

const contractAddress = '0x49EfD124C83DecB845D04b97631003c63a49568b';
const contractABI = [{"inputs":[{"internalType":"uint256","name":"_initialSupply","type":"uint256"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Transfer","type":"event"},{"stateMutability":"payable","type":"fallback"},{"inputs":[{"internalType":"uint256","name":"newPrice","type":"uint256"}],"name":"adjustTokenPrice","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"recepint","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"purchaseTokens","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"recepint","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"stateMutability":"payable","type":"receive"}]

const contract = new web3.eth.Contract(contractABI, contractAddress);

const funcgetEvents = async () => {
    try {
        const EventLogs = await contract.getPastEvents('Allevents', {fromBlock: 11104972, toBlock:11108960});
        console.log(EventLogs);

    }catch(err) {
        console.log(err);
    }
}
funcgetEvents();
