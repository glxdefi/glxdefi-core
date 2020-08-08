pragma solidity ^0.6.0;

//创建合约factory的接口
interface IGLXFactory {

    //游戏创建事件
    event GameCreated(address token, uint startBlockNumber, uint endBLockNumber, bool isOnChainGame);


    //创建游戏
    function createGame(
        address router,
        address extToken,//外部押注代币，如DAI
        address intToken,//内部发行代币，如gDAI
        address finToken,//defi生息地址
        address liquidPool,//流动性挖矿地址
        uint startBlockNumber,//游戏开始时间
        uint endBLockNumber,//游戏开奖时间
        bool isOnChainGame,//是否是以链上数据来做对赌标的游戏
        address gameObjectToken,//当是链上标的地址
        uint256 gameObjectTokenSupply//标的数据指标值
    )  external returns (address game);

    //extToken=>intToken
    function getIntToken(address extToken) external view returns (address intToken);

    //game=>extToken
    function getGameExtToken(address game) external view returns (address extToken);

    //intToken=>liquidPool
    function getLiquidPool(address intToken) external view returns (address liquidPool);

    //intToken=>mintDiscount
    function getMintDiscount(address intToken) external view returns (uint256 mintDiscount);


    //设置epoch减半率
    function setMintDiscount(address intToken, uint256 mintDiscount) external returns (bool);
}
