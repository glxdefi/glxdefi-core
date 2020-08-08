pragma solidity ^0.6.0;

import "./interface/IGLXFactory.sol";
import "./GLXGame.sol";
import "./GLXToken.sol";

contract GLXFactory is Ownable {

    //GLXGame => DAI
    mapping(address => address) public getGameExtToken;
    //DAI  => gDAI
    mapping(address => address) public getIntToken;
    //gDAI  => liquidPool
    mapping(address => address) public getLiquidPool;
    //gDAI  => mintDiscount;
    mapping(address => uint256) public getMintDiscount;

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
    ) external onlyOwner returns (address game) {

        require(extToken != address(0), 'GLXFactory: TOKEN_INVALID');
        require(intToken != address(0), 'GLXFactory: TOKEN_INVALID');

        game = _createGame(router, extToken, intToken, finToken, startBlockNumber, endBLockNumber, isOnChainGame, gameObjectToken, gameObjectTokenSupply);
        getGameExtToken[game] = extToken;

        if (getIntToken[extToken] == address(0)) {
            getIntToken[extToken] = intToken;
        }

        if (getLiquidPool[intToken] == address(0)) {
            getLiquidPool[intToken] = liquidPool;
            getMintDiscount[intToken] = uint256(1);
        }

        emit Game(game);
        return game;
    }

    event Game(address a);

    function _createGame(
        address router,
        address extToken,
        address intToken,
        address finToken,
        uint startBlockNumber,
        uint endBLockNumber,
        bool isOnChainGame,
        address gameObjectToken,
        uint256 gameObjectTokenSupply
    ) private returns (address game) {

        //创建游戏合约
        bytes memory bytecode = type(GLXGame).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(extToken));
        assembly {
            game := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        //初始化游戏合约参数
        IGLXGame(game).initialize(router, extToken, intToken, finToken, startBlockNumber, endBLockNumber, isOnChainGame, gameObjectToken, gameObjectTokenSupply);

        return game;
    }

    //设置epoch减半率
    function setMintDiscount(address intToken, uint256 mintDiscount) external onlyOwner returns (bool) {
        require(mintDiscount > 0, "GLXFactory: MINT_DISCOUNT_ZERO");
        require(intToken != address(0), "GLXFactory: INT_TOKEN_INVALID");
        require(getLiquidPool[intToken] != address(0), "GLXFactory: INT_TOKEN_NOT_EXIST");
        require(getMintDiscount[intToken] < mintDiscount, "GLXFactory: NEW_DISCOUNT_CANT_LESS");

        getMintDiscount[intToken] = mintDiscount;

        return true;
    }
}
