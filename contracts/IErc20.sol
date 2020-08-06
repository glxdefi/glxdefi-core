pragma solidity ^0.6.0;

interface IErc20 {
    function approve(address, uint256) external returns (bool);

    function transfer(address, uint256) external returns (bool);
}