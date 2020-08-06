pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract GLXToken is ERC20 {

    constructor(uint256 initialSupply)  public ERC20("GLXToken", "GLX"){
        _mint(msg.sender, initialSupply);
    }
}
