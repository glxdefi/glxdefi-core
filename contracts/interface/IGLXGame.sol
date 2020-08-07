pragma solidity ^0.6.0;

interface IGLXGame {

    event Initialize(address _router, address _token);
    event Bet(address account, bool direction, uint256 amount);
    event Receive(address account);

    // 初始化
    function initialize(address _router, address _token) external;

    // 押注
    function bet(address account, bool direction, uint256 amount) external returns (bool);

    // 开奖
    function receive(address account) external returns (bool);

    // 游戏开始，报名截止
    function startGame() external returns (bool);

    // 游戏截止，可以领奖了
    function endGame() external returns (bool);

    //当对赌的标的 是链下数据，需要oracle喂结果
    function updateGameResultByOracle(bool direction) external returns (bool);
}
