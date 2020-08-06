pragma solidity ^0.6.0;

contract IGLXGame {

    event Transfer(address indexed from, address indexed to, uint256 value);

    function transfer(address recipient, uint256 amount) public virtual override returns (bool);
}
