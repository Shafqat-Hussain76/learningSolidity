// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

interface IERC20 {
    function balanceOf(address account) external view returns(uint256);
    function transfer(address recepint, uint256 amount) external returns(bool);
    function approve(address spender, uint256 amount) external returns(bool);
    function allowance(address recepint, address spender) external view returns(uint256);
    function transferFrom(address from, address to, uint amount) external returns(bool);
    function totalSupply() external view returns(uint256);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed from, address indexed to, uint256 amount);
}

contract ERC20 is IERC20 {
    
    mapping (address => uint256) private balances;
    mapping (address => mapping(address => uint256)) private allowed;
    uint256 initialSupply;
    address owner;
    uint256 priceToken = 100;
    uint256 cap;
    uint curdate = block.timestamp;
    
    constructor(uint256 _initialSupply) {
        initialSupply = _initialSupply;
        owner = msg.sender;
        balances[owner] = initialSupply;
        cap = 2 * initialSupply; // 
    }
    
    function totalSupply() external override view returns(uint256) {
        return cap;
    }
    
    function balanceOf(address account) external override view returns(uint256) {
        return balances[account];
    }
    
    function purchaseTokens() public payable  {
        require(msg.sender != owner, "Owner cannot purchase tokens");
        require(msg.value >= 1 ether, "Value should be in ethers");
        require(msg.sender != address(0));
        balances[msg.sender] += (msg.value / (10**18)) * priceToken; //1 ether = 100 tokens
        balances[owner] -= (msg.value / (10 **18)) * priceToken;
    }
    
    function adjustTokenPrice(uint newPrice) public {
        priceToken = newPrice; //1 ether = new price of tokens
    }
    
    function transfer(address recepint, uint256 amount) public override returns(bool) {
        require(block.timestamp >= curdate + 30 days, "Wages will be given after one month");
        require(balances[msg.sender] >= amount, "you dont have enogh toekns");
        require(msg.sender != address(0) && recepint != address(0));
        require(amount > 0, "Toeken should be greater than 0");
        balances[msg.sender] -= amount;
        balances[recepint] += amount;
        emit Transfer(msg.sender, recepint, amount);
        return true;
    }
    
    function approve(address spender, uint256 amount) public override returns(bool) {
        require(msg.sender != address(0) && spender != address(0));
        require(amount > 0, "Toeken should be greater than 0");
        allowed[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    function allowance(address recepint, address spender) public override view returns(uint256) {
        return allowed[recepint][spender];
    }
    function transferFrom(address from, address to, uint amount) public override returns(bool) {
        require(amount <= balances[from] && amount <= allowed[from][msg.sender], "balance Low or not approved");
        require(block.timestamp >= curdate + 30 days, "Wages will be given after one month");
        require(from != address(0) && to != address(0));
        require(amount > 0, "Toeken should be greater than 0");
        balances[to] += amount;
        balances[from] -= amount;
        allowed[from][msg.sender] -=amount;
        emit Transfer(from, to, amount);
        return true;
    }
    function mint(address account, uint amount) public{
        require(msg.sender == owner, "You are not allowed");
        require((initialSupply + amount) <=cap, "The limit is exceeded");
        balances[account] += amount;
        balances[owner] += amount;
    }
    fallback() external payable {
        purchaseTokens();
    }
    receive() external payable {
        
    }
}