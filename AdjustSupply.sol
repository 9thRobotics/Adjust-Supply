// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdjustableSupplyToken {
    string public name = "AdjustableSupplyToken";
    string public symbol = "AST";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    address public admin;

    mapping(address => uint256) public balanceOf;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Caller is not the admin");
        _;
    }

    constructor(uint256 initialSupply) {
        admin = msg.sender;
        totalSupply = initialSupply * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    // Mint function to increase the supply
    function mint(uint256 amount) internal {
        totalSupply += amount;
        balanceOf[admin] += amount;
        emit Transfer(address(0), admin, amount);
    }

    // Burn function to decrease the supply
    function burn(uint256 amount) internal {
        require(balanceOf[admin] >= amount, "Insufficient balance to burn");
        totalSupply -= amount;
        balanceOf[admin] -= amount;
        emit Transfer(admin, address(0), amount);
    }

    // Adjust supply function
    function adjustSupply(uint256 newSupply) external onlyAdmin {
        require(newSupply > 0, "Invalid supply amount");
        if (newSupply > totalSupply) {
            mint(newSupply - totalSupply);
        } else {
            burn(totalSupply - newSupply);
        }
    }
}
