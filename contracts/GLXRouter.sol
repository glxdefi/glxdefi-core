pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./interface/IGLXRouter.sol";


contract GLXRouter is IGLXRouter,Ownable {

    address public factory;

    //USDT  => GUSDT
    mapping(address => address) public extToken2IntToken;

    modifier onlyFactory() {
        require(msg.sender == factory, 'GLXGame: FORBIDDEN'); // sufficient check
        _;
    }


    function addExtToken2IntToken(address extToken, address intToken) external onlyFactory {
        extToken2IntToken[extToken] = intToken;
    }

    function setFactory(address _factory) external onlyOwner {
        require(_factory != address(0), 'GLXRouter: ADDRESS_NULL');
        factory = _factory;
    }
}
