pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./interface/IGLXRouter.sol";
import "./interface/IGLXFactory.sol";
import "./interface/IGLXGame.sol";

import "./library/GLXHelper.sol";

contract GLXRouter is IGLXRouter,Ownable {

    address public factory;


    constructor(address _factory) public {
        require(_factory != address(0), 'GLXRouter: ADDRESS_NULL');

        factory = _factory;
    }

    modifier validGame(address game) {
        require(game != address(0), 'GLXRouter: GAME_INVALID');
        require(IGLXFactory(factory).getGameExtToken[game] == address(0), 'GLXRouter: GAME_NOT_EXIST');
        _;
    }

    // 押注
    function bet(
        address game,
        address extToken,
        bool direction,
        uint256 amount
    ) external validGame(game) returns (bool) {
        require(extToken != address(0), 'GLXRouter: GAME_EXTERNAL_TOKEN_INVALID');
        require(IGLXFactory(factory).getIntToken[extToken] != address(0), 'GLXRouter: EXT_TOKEN_NOT_HAVE_INT_TOKEN');
        require(IGLXFactory(factory).getGameExtToken[game] == extToken, 'GLXRouter: GAME_EXT_TOKEN_NOT_MATCH');

        GLXHelper.safeTransferFrom(extToken, msg.sender, game, amount);

        require(IGLXGame(game).bet(msg.sender, direction, amount), 'GLXRouter: GAME_BET_FAILED');

        return true;
    }

    // 用户自行领奖：减少平台发奖成本开销
    function receive(address game) external validGame(game) returns (bool) {

        require(IGLXGame(game).receive(msg.sender), 'GLXRouter: GAME_RECEIVE_FAILED');

        return true;
    }


    //当对赌的标的 是链下数据，需要oracle喂结果
    function updateGameResultByOracle(address game, bool direction) external olnyOwner validGame(game) returns (bool) {

        require(IGLXGame(game).updateGameResultByOracle(direction), 'GLXRouter: GAME_ORACLE_FAILED');

        return true;
    }
}
