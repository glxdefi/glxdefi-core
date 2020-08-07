pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockErc20 is ERC20 {

    constructor(uint256 initialSupply) public ERC20("MockDAI", "DAI") {
        _mint(msg.sender, initialSupply);
    }
}
