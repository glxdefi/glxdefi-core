pragma solidity ^0.6.0;

//游戏接口层
interface IGLXGame {


    // 初始化
    function initialize(address _router, address _extToken,address intToken, address _finToken, uint _startBlockNumber, uint _endBlockNumber, bool _isOnChainGame, address _gameObjectToken,uint256 _gameObjectTokenSupply)  external;

    // 押注
    function bet(address account, bool direction, uint256 amount) external returns (bool);

    // 获取收益
    function receiveIncome(address account) external returns (bool);

    //当对赌的标的 是链上数据，需要触发开奖,谁都可以来开奖
    function updateGameResult() external returns (bool);

    //当对赌的标的 是链下数据，需要oracle喂结果;防止缺省值影响，2代表true正方赢， 1代表false 反方赢，
    function updateGameResultByOracle(uint8 _gameResult) external returns (bool);

    //是否可以提取游戏奖品了
    function isCanReceive() external view returns (bool);

    //查看自己是否有需要提取的收益
    function isExistIncomeNeedReceive(address account) external view returns (bool);

    //查看自己本场的收益额度，即使领取过了，也可以查
    function getIncomeAmount(address account) external view returns (uint256);

    //查看当前已经有多少人员押注
    function getCurUserCount() external view returns (uint);
}
