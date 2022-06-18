const Web3 = require('web3');
const rpcurl = 'https://ropsten.infura.io/v3/22e41a0082b44d1e9e920225f861bcdf';
const web3 = new Web3(rpcurl);

const funcprtac = async () => {
    try {
        const gasprice = await web3.eth.getGasPrice();
        console.log(gasprice);
        const gaspriceether = web3.utils.fromWei(gasprice, 'ether');
        console.log("Gas Price in Ether :" + gaspriceether);
        console.log(web3.utils.sha3('Shafqat HUssain'));
        console.log(web3.utils.keccak256('Shafqat Hussain'));

    }catch(err) {
        console.log(err);
    }
}
funcprtac();