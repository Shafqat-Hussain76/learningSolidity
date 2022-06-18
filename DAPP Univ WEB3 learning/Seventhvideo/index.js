const Web3 = require('web3');
const rpcurl = 'https://ropsten.infura.io/v3/22e41a0082b44d1e9e920225f861bcdf';
const web3 = new Web3(rpcurl);

const fungetblock = async () => {
    try {
        const lstblock = await web3.eth.getBlock('latest');
        console.log(lstblock);
        console.log({
            hash:lstblock.hash,
            num:lstblock.number
        })
        const lstblocknumber = await web3.eth.getBlockNumber();
        for(let i = 0; i <=10; i++) {
            latestblocks = await web3.eth.getBlock(lstblocknumber - i);
            console.log(latestblocks.number);
        }

    }catch(err) {
        console.log(err)
    }
    
}
fungetblock();