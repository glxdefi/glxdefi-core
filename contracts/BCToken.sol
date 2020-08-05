pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BCToken is ERC20 {

    constructor(uint256 initialSupply) public ERC20("BCToken", "BCT") {
        _mint(msg.sender, initialSupply);
    }
}
