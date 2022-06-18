const Web3 = require('web3');
rpcurl = 'https://ropsten.infura.io/v3/22e41a0082b44d1e9e920225f861bcdf'; // To connect with Ropsten
const web3 = new Web3(rpcurl);

const acc1 = '0x29B574ddAD30F1b5EB8907f2BC04bBf61761c1a2'; //Adres taken from metamask (account1)
const acc2 = '0xFE2c44CB675bA74336DB483a6479830dD453Cd1f'; //Adres taken from metamask (account2)


funcGetBalance = async () => {
    try {
        const balance1 = await web3.eth.getBalance(acc1);
        const balance2 = await web3.eth.getBalance(acc2);
        console.log("Balance of Acc1 is (wei) ", balance1);
        console.log("Balance of Acc2 is (wei) ", balance2);
        let elem = document.getElementById('one');
        
        const balance1ether = await web3.utils.fromWei(balance1, 'ether');
        const balance2ether = await web3.utils.fromWei(balance2, 'ether');
        console.log("Balance of Acc1 is (Ether) ", balance1ether);
        console.log("Balance of Acc2 is (Ether) ", balance2ether);

    }catch(err) {
        console.log(err);
    }
}
funcGetBalance();