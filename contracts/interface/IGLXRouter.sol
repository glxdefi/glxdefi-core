pragma solidity ^0.4.0;

interface IGLXRouter {


    // 押注
    function bet(address account, bool direction, uint256 amount) external returns (bool);

    // 开奖
    function receive(address account) external returns (bool);
}
