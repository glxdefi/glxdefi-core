pragma solidity ^0.6.0;

interface IGLXGame {

    event Initialize(address _router, address _token);
    event Bet(address account, bool direction, uint256 amount);
    event Receive(address account);

    // 初始化
    function initialize(address _router, address _token) external;

    // 押注
    function bet(address account, bool direction, uint256 amount) public returns (bool);

    // 开奖
    function receive(address account) public returns (bool);
}
