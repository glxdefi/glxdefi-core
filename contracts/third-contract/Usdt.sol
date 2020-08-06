pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Usdt is ERC20 {

    constructor() public ERC20("Usdt", "USDT") {
        _mint(msg.sender, 100000000000000000);
    }
}
