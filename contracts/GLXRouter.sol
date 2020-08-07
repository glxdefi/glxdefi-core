pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./interface/IGLXRouter.sol";


contract GLXRouter is IGLXRouter,Ownable {

    address public factory;


    constructor(address _factory) public {
        require(_factory != address(0), 'GLXRouter: ADDRESS_NULL');
        factory = _factory;
    }


}
