pragma solidity ^0.6.0;

interface IGLXGame {

    event Initialize(address _router, address _token);
    event Bet(address account, bool direction, uint256 amount);
    event Receive(address account);

    // 初始化
    function initialize(address _router, uint _startBlockNumber, uint _endBlockNumber, bool _isOnChainGame, address _gameObjectToken,uint256 _gameObjectTokenSupply)  external;

    // 押注
    function bet(address account, bool direction, uint256 amount) external returns (bool);

    // 开奖
    function receive(address account) external returns (bool);

    //当对赌的标的 是链上数据，需要触发开奖,谁都可以来开奖
    function updateGameResult() external lock whenEnded returns (bool);

    //当对赌的标的 是链下数据，需要oracle喂结果;防止缺省值影响，2代表true正方赢， 1代表false 反方赢，
    function updateGameResultByOracle(uint8 _gameResult) external lock onlyRouter whenEnded returns (bool);

    //是否可以提取游戏奖品了
    function isCanReceive() public view returns (bool);

    //查看是否拥有需要提取的奖品
    function isExistBonusNeedReceive() public view returns (bool);
}
