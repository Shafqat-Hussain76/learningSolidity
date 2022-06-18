require('dotenv').config();

const Tx = require('ethereumjs-tx').Transaction;

const Web3 = require('web3');
const rpcurl = 'https://ropsten.infura.io/v3/22e41a0082b44d1e9e920225f861bcdf';
const web3 = new Web3(rpcurl);

const acc1 = '0x29B574ddAD30F1b5EB8907f2BC04bBf61761c1a2';
const acc2 = '0xFE2c44CB675bA74336DB483a6479830dD453Cd1f';
const acc1pvtkey = Buffer.from(process.env.acc1_pvt_key, 'hex');

const fubcsendETher = async ()=> {
    try {
        const txCount = await web3.eth.getTransactionCount(acc1);
        const txObject = {
            nonce : web3.utils.toHex(txCount),
            to: acc2,
            gasLimit: web3.utils.toHex(1000000),
            gasPrice: web3.utils.toHex(web3.utils.toWei('10', 'gWei')),
            value: web3.utils.toHex(web3.utils.toWei('0.2', 'ether'))
        }
        const tx = new Tx(txObject, { 'chain':'ropsten' });
        tx.sign(acc1pvtkey);
        const TXSERIALIZED = tx.serialize();
        const raw = '0x' + TXSERIALIZED.toString('hex');
        const response = await web3.eth.sendSignedTransaction(raw);
        console.log(response);
    }catch(err) {
        console.log(err);
    }
}

fubcsendETher();