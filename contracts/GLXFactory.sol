pragma solidity ^0.6.0;

import "./interface/IGLXFactory.sol";
import "./GLXGame.sol";
import "./GLXToken.sol";

//factory合约：用于创建不同代币参与，以及不同时间维度和不同对赌标的的游戏
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
        address router,//router地址
        address extToken,//外部押注代币，如DAI
        address intToken,//内部发行代币，如gDAI
        address finToken,//defi生息地址
        address liquidPool,//流动性挖矿地址
        uint startBlockNumber,//游戏开始高度
        uint endBlockNumber,//游戏开奖高度
        bool isOnChainGame,//是否是以链上数据来做对赌标的游戏
        address gameObjectToken,//当是链上标的地址
        uint256 gameObjectTokenSupply//标的数据指标值
    ) external onlyOwner returns (address game) {

        require(extToken != address(0), 'GLXFactory: TOKEN_INVALID');
        require(intToken != address(0), 'GLXFactory: TOKEN_INVALID');

        game = _createGame(router, extToken, intToken, finToken, startBlockNumber, endBlockNumber, isOnChainGame, gameObjectToken, gameObjectTokenSupply);
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

    //创建游戏
    function _createGame(
        address router,
        address extToken,
        address intToken,
        address finToken,
        uint startBlockNumber,
        uint endBlockNumber,
        bool isOnChainGame,
        address gameObjectToken,
        uint256 gameObjectTokenSupply
    ) private returns (address game) {

        //创建游戏合约
        bytes memory bytecode = type(GLXGame).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(startBlockNumber));
        assembly {
            game := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        //初始化游戏合约参数
        IGLXGame(game).initialize(router, extToken, intToken, finToken, startBlockNumber, endBlockNumber, isOnChainGame, gameObjectToken, gameObjectTokenSupply);

        return game;
    }

    //设置epoch减半率
    function setMintDiscount(address intToken, uint256 mintDiscount) external onlyOwner returns (bool) {
        require(intToken != address(0), "GLXFactory: INT_TOKEN_INVALID");
        require(getLiquidPool[intToken] != address(0), "GLXFactory: INT_TOKEN_NOT_EXIST");
        require(getMintDiscount[intToken] < mintDiscount, "GLXFactory: NEW_DISCOUNT_CANT_LESS");

        getMintDiscount[intToken] = mintDiscount;

        return true;
    }
}
