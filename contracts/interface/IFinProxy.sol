pragma solidity ^0.6.0;

interface IFinProxy {

    // 提交erc20
    // 参数：token、receiver、amount
    function supply(address, address, uint256) external;
    // 赎回erc20
    // 参数：from、amount
    function redeem(address, uint256) external returns (bool);

}
