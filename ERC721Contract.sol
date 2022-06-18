// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

interface IERC721 {
    function balanceOf(address owner) external view returns(uint256);
    function ownerOf(uint256 tokenId) external view returns(address);
    function setApprovalForAll(address operator, bool approved) external;
    function isApprovedForAll(address owner, address operator) external view returns(bool);
    function approve(address approval, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns(address);
    function transferFrom(address from, address to, uint256 tokenId) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external  returns(bool);
}

interface IERC721Metadata is IERC721 {
    function name() external view returns(string memory);
    function symbol() external view returns(string memory);
    function tokenURI(uint256 tokenId) external view returns(string memory);
}

contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public pure override virtual returns(bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

contract ERC721 is IERC721, IERC721Metadata, ERC165 {
    using Strings for uint256;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApproval;
    mapping (address => mapping(address => bool)) private _operatorApproval;
    
    string private _name;
    string private _symbol;
    string private _baseuri = 'https://floydnft.com/token/'; //Default but owner can change it
    uint8 tokenLimit;
    address private _ownerOfContract;
    uint256 salestart;
    uint256 tokenPriceInEther;
    
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _ownerOfContract = msg.sender;
        
    }
    function supportsInterface(bytes4 interfaceId) public pure override returns(bool) {
        return
        interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC165).interfaceId || super.supportsInterface(interfaceId);
    }
    
    function name() public view override returns(string memory){
        return _name;
        
    }
    function symbol() public view override returns(string memory) {
        return _symbol;
    }
    function tokenURI(uint256 tokenId) public override view returns(string memory) {
        require(_exsists(tokenId), "Token does not exsist");
        string memory baseuri = _baseuri;
        return bytes(baseuri).length > 0 ? string(abi.encodePacked(baseuri, tokenId.toString())) : "";
        
    }
    
    function setBaseURI(string memory baseuri) public{
        require(msg.sender == _ownerOfContract,"Only Owner can set base uri");
        _baseuri = baseuri;
    }
    
    function _exsists(uint256 tokenId) internal view returns(bool) {
        return _owners[tokenId] != address(0);
    }
    function balanceOf(address owner) public view override returns(uint256){
        require(owner != address(0), "The Owner is no valid");
        return _balances[owner];
    }
    
    function ownerOf(uint256 tokenId) public view override returns(address) {
        require(_owners[tokenId] != address(0), "Invalid Token");
        return _owners[tokenId];
    }
    function setApprovalForAll(address operator, bool approved) public override {
        require(operator != msg.sender, "Not Valid operator");
        _operatorApproval[msg.sender][operator] = approved;
    }
    function isApprovedForAll(address owner, address operator) public view override returns(bool) {
        return _operatorApproval[owner][operator];
    }
    
    function approve(address approval, uint256 tokenId) public override {
        address owner = _owners[tokenId];
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "You are not authorized");
        _tokenApproval[tokenId] = approval;
    }
    
    function getApproved(uint256 tokenId) public view override returns(address) {
        require(_exsists(tokenId), "Token not Exsists");
        return _tokenApproval[tokenId];
    }
    
    function _transfer(address from, address to, uint256 tokenId) internal {
        require(_owners[tokenId] == from, "not valid token");
        require(to != address(0), "The receiving address is not valid");
        approve(address(0), tokenId);
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
    }
    
    function _isApprovedOwner(uint256 tokenId, address approval) internal view returns(bool) {
        address owner = _owners[tokenId];
        return (msg.sender == owner || getApproved(tokenId) == approval || isApprovedForAll(owner, approval));
    }
    
    function transferFrom(address from, address to, uint256 tokenId) public override {
        require(_isApprovedOwner(tokenId, from),"you are not authorized");
        _transfer(from, to, tokenId);
        
    }
    function safeTransferFrom(address from, address to, uint256 tokenId) external override {}
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external override{}
    
    function _mint(address to, uint256 tokenId) internal {
        require(!_exsists(tokenId),"Token Already Exsists");
        require(to != address(0), "No a valid address");
        require(tokenLimit <= 99 ," Token Limit is exceeded to 100");
        _owners[tokenId] = to;
        _balances[to] += 1;
        tokenLimit++;
    }
    
    function _burn(uint256 tokenId) internal {
        require(_exsists(tokenId), "Token not valid");
        address owner = _owners[tokenId];
        _balances[owner] -= 1;
        delete _owners[tokenId];
        approve(address(0), tokenId);
    }
    
    function saleStart() public{
        require(msg.sender == _ownerOfContract, "You are not authorized to satrt sale");
        salestart = block.timestamp;
    }
    
    function tokenPrice(uint256 k) public {
        require(msg.sender == _ownerOfContract, "You are not authorized to satrt sale");
        tokenPriceInEther = k;
    }
    
    function buyToekns(address to, uint256 tokenId) public payable {
        require((block.timestamp >= salestart) && (block.timestamp <= salestart + 30 days), "Token sale is Not Available");
        require(msg.value >= 1 ether, "Please provide value in ether");
        require(msg.value == tokenPriceInEther * 1 ether, "The price of Token is not valid");
        _mint(to, tokenId);
    }
    
    function contractBal() public payable returns(uint256) {
        return payable(address(this)).balance;
    }
    fallback() external payable{}
    receive() external payable{}
   
    
}

//---------------------------------------------------------------------------------------------------------
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}
