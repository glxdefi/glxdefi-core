pragma solidity ^0.6.0;

import "./interface/IGLXFactory.sol";
import "./GLXGame.sol";
import "./GLXToken.sol";

contract GLXFactory is Ownable {

    address public feeTo;

    //GLXGame => DAI
    mapping(address => address) public getGameExtToken;
    //DAI  => gDAI
    mapping(address => address) public getIntToken;
    //gDAI  => liquidPool
    mapping(address => address) public getLiquidPool;


    constructor() public {
        feeTo = msg.sender;
    }


    //创建游戏合约，当游戏合于对应的代币没有创建是，还会自动创建代币
    function createGame(
        address router,
        address extToken,
        address intToken,
        address finToken,
        address liquidPool,
        uint startBlockNumber,
        uint endBLockNumber,
        bool isOnChainGame,
        address gameObjectToken,
        uint256 gameObjectTokenSupply
    ) external returns (address game) {

        require(extToken != address(0), 'GLXFactory: TOKEN_INVALID');
        require(intToken != address(0), 'GLXFactory: TOKEN_INVALID');

        game = _createGame(router, extToken, finToken, startBlockNumber, endBLockNumber, isOnChainGame, gameObjectToken, gameObjectTokenSupply);
        getGameExtToken[game] = extToken;

        if (getIntToken[extToken] == address(0)) {
            getIntToken[extToken] = intToken;
        }

        if (getLiquidPool[intToken] == address(0)) {
            getLiquidPool[intToken] = liquidPool;
        }

        return game;
    }


    function _createGame(
        address router,
        address extToken,
        address finToken,
        uint startBlockNumber,
        uint endBLockNumber,
        bool isOnChainGame,
        address gameObjectToken,
        uint256 gameObjectTokenSupply
    ) private returns (address game){

        //创建游戏合约
        bytes memory bytecode = type(GLXGame).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(extToken));
        assembly {
            game := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        //初始化游戏合约参数
        IGLXGame(game).initialize(router, extToken, finToken, startBlockNumber, endBLockNumber, isOnChainGame, gameObjectToken, gameObjectTokenSupply);

        return game;
    }


    function setFeeTo(address _feeTo) external onlyOwner {
        require(_feeTo != address(0), 'GLXFactory: ADDRESS_NULL');
        feeTo = _feeTo;
    }

}
