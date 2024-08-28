// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {
    constructor() ERC20("ExampleToken", "ETK") Ownable(msg.sender) {
        _mint(msg.sender, 1000000 * 10 ** decimals()); // Mint initial supply to the owner
    }
}

contract TokenSale is Ownable {
    Token public token;
    uint256 public rate; // Number of tokens per Ether

    event TokensPurchased(address buyer, uint256 amountSpent, uint256 tokensIssued);

    constructor(Token _token, uint256 _rate) Ownable(msg.sender) {
        token = _token;
        rate = _rate;
    }

    receive() external payable {
        uint256 tokensToIssue = msg.value * rate;
        require(token.balanceOf(address(this)) >= tokensToIssue, "Insufficient token balance");
        token.transfer(msg.sender, tokensToIssue);
        emit TokensPurchased(msg.sender, msg.value, tokensToIssue);
    }

    function withdraw(uint256 amount) external onlyOwner {
        payable(owner()).transfer(amount);
    }

    function updateRate(uint256 newRate) external onlyOwner {
        rate = newRate;
    }
}
