pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./interface/IGLXRouter.sol";


contract GLXRouter is IGLXRouter,Ownable {

    address public factory;

    //USDT  => GUSDT
    mapping(address => address) public getIntToken;
    //GLXGame => USDT
    mapping(address => address) public getGameExtToken;



    constructor(address _factory) public {
        require(_factory != address(0), 'GLXRouter: ADDRESS_NULL');
        factory = _factory;
    }

    modifier onlyFactory() {
        require(msg.sender == factory, 'GLXRouter: FORBIDDEN'); // sufficient check
        _;
    }

    function addIntToken(address extToken, address intToken) external onlyFactory {
        getIntToken[extToken] = intToken;
    }

    function addGameExtToken(address game, address extToken) external onlyFactory {
        getGameExtToken[game] = extToken;
    }




}
