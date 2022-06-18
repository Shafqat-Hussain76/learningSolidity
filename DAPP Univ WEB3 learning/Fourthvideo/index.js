require("dotenv").config();
const Web3 = require('web3');
rpcurl ='https://ropsten.infura.io/v3/22e41a0082b44d1e9e920225f861bcdf';
const web3 = new Web3(rpcurl);
const Tx = require('ethereumjs-tx').Transaction;

const acc1 = '0x29B574ddAD30F1b5EB8907f2BC04bBf61761c1a2'
const acc1pvtkey = Buffer.from(process.env.acc1_pvt_key, 'hex');
const contractByteCode = '608060405234801561001057600080fd5b5060c78061001f6000396000f3fe6080604052348015600f57600080fd5b506004361060325760003560e01c80632e64cec11460375780636057361d146053575b600080fd5b603d607e565b6040518082815260200191505060405180910390f35b607c60048036036020811015606757600080fd5b81019080803590602001909291905050506087565b005b60008054905090565b806000819055505056fea26469706673582212202769ab8e25743062535549eb645d19a9ce8bfd2a64eac6c1a328e81f7559cc7d64736f6c63430007040033';
const contractByteCodeHex = Buffer.from(contractByteCode, 'hex');

const funcContractDeploy = async () => {
    try {
        const txCount = await web3.eth.getTransactionCount(acc1);
        const TxObject = {
            nonce: web3.utils.toHex(txCount),
            data: contractByteCodeHex,
            gasPrice: web3.utils.toHex(web3.utils.toWei('10', 'gWei')),
            gasLimit: web3.utils.toHex(1000000)
        }

        const tx = new Tx(TxObject, { 'chain':'ropsten' });
        tx.sign(acc1pvtkey);
        const serializedTX = tx.serialize();
        const raw = '0x' + serializedTX.toString('hex');

        const response = await web3.eth.sendSignedTransaction(raw);
        console.log(response);

    }catch(err) {
        console.log(err);
    }
}
funcContractDeploy();

