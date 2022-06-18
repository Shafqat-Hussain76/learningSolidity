// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract Bank {
    
    address BankOwner; //Address of Owner of Bank
    
    mapping( address => uint) bankBal; // Bank total balance including initial amount, accounts balance and deduction of any bonus
    mapping( address => uint) AcHoldsBalances; //Account holders balance
    mapping( address => AcHolCnrl) control; // Control on Bank account and accountHolders
    
    address[] bonus;
    
    struct AcHolCnrl { bool newAcHol; bool acHolAct; bool bankOpen; }
    
    constructor() {
        BankOwner = msg.sender;
    }
    //Only contract owner create bank with minimum 50 ethers and only one bank can be opened.
    function open_Bank () public payable {
        
        require(msg.sender == BankOwner, "you are not owner of the bank");
        require(msg.value >= 50 ether, "The Opening Banking balance is low");
        require(!control[msg.sender].bankOpen,"The Bank alreay exsists");
        bankBal[address(this)] += msg.value;
        control[msg.sender].bankOpen = true;
        
    }
    //only owner can close bank
    function close_Bank() public payable{
        
        require(msg.sender == BankOwner, "Only Bank Owner can close the bank");
        selfdestruct(payable(BankOwner));
      
    }
    
    //One address has only one account, first 5 unique address will get 1 ether as bouns. Bouns will be paid by bank
    function acc_NewOpen() public payable {
        
        require(!control[msg.sender].newAcHol, "You have already Account");
        require(msg.value >= 0 ether, "Please need ethers to open the account");
        require(control[BankOwner].bankOpen == true, "Bank is not Opened");
        if (bonus.length <= 4) {
            AcHoldsBalances[msg.sender] = msg.value + 1 ether;
            bankBal[address(this)] += msg.value -1 ether;
            bonus.push(msg.sender);
        } else {
            AcHoldsBalances[msg.sender] = msg.value;
            bankBal[address(this)] += msg.value;
        }
        control[msg.sender].newAcHol = true;
        
    }
    
    //only active accounts can deposit
    function acc_Deposit() public payable {
        
        require(!control[msg.sender].acHolAct, "Your Account is deactivated");
        require(control[BankOwner].bankOpen == true, "Bank is not Opened");
        AcHoldsBalances[msg.sender] += msg.value;
        bankBal[address(this)] += msg.value;
        
    }
    
    //only active accounts can withdraw if deposit balance is more than withdraw balance
    function acc_Wdraw(address _to, uint _ether) public payable {
        
        require(_ether <= AcHoldsBalances[msg.sender], "Account has no sufficient Ethers");
        require(!control[msg.sender].acHolAct, "Your Account is deactivated");
        require(control[BankOwner].bankOpen == true, "Bank is not Opened");
        payable(_to).transfer(_ether);
        AcHoldsBalances[msg.sender] -= _ether;
        bankBal[address(this)] -= _ether;
        
    }
    
    //Bank Balance
    function bank_Bal() public view returns(uint){
        require(msg.sender == BankOwner, "You are not Authorized");
        require(control[BankOwner].bankOpen == true, "Bank is not Opened");
        return bankBal[address(this)];
        
    }
    
    //individula account Balance
    function acc_Bal(address _add) public view returns(uint){
        
        require(control[BankOwner].bankOpen == true, "Bank is not Opened");
        require(!control[msg.sender].acHolAct, "Your Account is deactivated");
        return AcHoldsBalances[_add];
        
    }
    
    //Only Bankowner can close the account
    function acc_Close(address _add) public {
        
        control[_add].acHolAct = true;
        
    }
    
    receive() external payable {
        
    }
}

   