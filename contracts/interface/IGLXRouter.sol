pragma solidity ^0.4.0;

interface IGLXRouter {

    // 押注
    function bet(address game, address extToken, bool direction, uint256 amount) external returns (bool);

    // 用户领奖领奖：减少平台发奖成本开销
    function receive(address game) external returns (bool);

    //当对赌的标的 是链下数据，需要oracle喂结果
    function updateGameResultByOracle(address game, bool direction) external returns (bool);
}
