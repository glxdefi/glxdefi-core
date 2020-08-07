pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./interface/IGLXRouter.sol";
import "./interface/IGLXFactory.sol";

import "./library/GLXHelper.sol";

contract GLXRouter is IGLXRouter,Ownable {

    address public factory;


    constructor(address _factory) public {
        require(_factory != address(0), 'GLXRouter: ADDRESS_NULL');

        factory = _factory;
    }


    // 押注
    function bet(address game, address extToken, bool direction, uint256 amount) external returns (bool){
        require(IGLXFactory(factory).getIntToken[extToken] != address(0), 'GLXRouter: EXT_TOKEN_NOT_');
        require(IGLXFactory(factory).getGameExtToken[game] != extToken, 'GLXRouter: GAME_');

        GLXHelper.safeTransferFrom(extToken);
        return true;
    }

    // 用户领奖领奖：减少平台发奖成本开销
    function receive(address game) external returns (bool);

    // 游戏开始，报名截止
    function startGame(address game) external returns (bool);

    // 游戏截止，可以领奖了
    function endGame(address game) external returns (bool);

    //当对赌的标的 是链下数据，需要oracle喂结果
    function gameResultOracle(address game, bool direction) external returns (bool);
}
