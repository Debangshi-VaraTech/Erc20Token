// SPDX-License-Identifier: MIT
pragma solidity 0.7.0;


import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract BondToken is ERC20 {
    address public owner;

    // Mapping to store the balance of each user
    mapping(address => uint256) public userBalances;

    // Mapping to store user wallet addresses
    mapping(address => address) public userWallets;

    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        owner = msg.sender;
        _mint(msg.sender, initialSupply * 10 ** uint256(decimals()));
    }

    // Enlist Bond- working
    function enlistBond(string memory bondSymbol, uint256 quantity, address user) public returns (bool) {
        require(msg.sender == owner, "Only owner can enlist bonds");
        _mint(user, quantity * 10 ** uint256(decimals()));
        return true;
    }

    // Create Wallet- working
    function createWallet(address user, address walletAddress) public {
        require(msg.sender == owner || msg.sender == user, "Only owner or user can create a wallet");
        userWallets[user] = walletAddress;
    }

    // Register Demat- working
    function registerDemat(address user, string memory dematId, address  walletAddress) public {
        require(msg.sender == owner || msg.sender == user, "Only owner or user can register a demat");
        require(userWallets[user] == walletAddress, "Invalid wallet address");
    }

    // Burn Bonds
    function burnBond(uint256 quantity) public {
        require(quantity > 0, "Quantity must be greater than 0");
        require(userBalances[msg.sender] >= quantity, "Not enough bonds to burn");

        _burn(msg.sender, quantity);
        userBalances[msg.sender] -= quantity;
    }

    // Buy Bonds
    function buyBonds(uint256 quantity) public {
        require(quantity > 0, "Quantity must be greater than 0");
        require(balanceOf(owner) >= quantity, "Not enough bonds available for purchase");
        require(userBalances[msg.sender] + quantity >= quantity, "Overflow error");

        transferFrom(owner, msg.sender, quantity);
        userBalances[msg.sender] += quantity;
    }

    // Sell Bonds
    function sellBonds(uint256 quantity) public {
        require(quantity > 0, "Quantity must be greater than 0");
        require(userBalances[msg.sender] >= quantity, "Not enough bonds to sell");
        require(balanceOf(owner) + quantity >= balanceOf(owner), "Overflow error");

        transfer(owner, quantity);
        userBalances[msg.sender] -= quantity;
    }

    // Get user's bond balance currently using "balanceOf" function to fetch the balance
    function getUserBondBalance(address user) public view returns (uint256) {
        return userBalances[user];
    }
}



