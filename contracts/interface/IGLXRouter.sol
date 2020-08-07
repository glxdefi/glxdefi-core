pragma solidity ^0.6.0;

interface IGLXRouter {

    // 押注
    function bet(address game, address extToken, bool direction, uint256 amount) external returns (bool);

    // 用户领奖领奖：减少平台发奖成本开销
    function getIncome(address game) external returns (bool);

    //当对赌的标的 是链上数据，需要触发开奖
    function updateGameResult(address game) external returns (bool);

    //当对赌的标的 是链下数据，需要oracle喂结果
    function updateGameResultByOracle(address game, bool direction) external returns (bool);
}
