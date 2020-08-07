pragma solidity ^0.6.0;

interface IFinProxy {

    function supplyUsdt(uint256) external;
    function redeemUsdt(uint256) external returns (bool);

}
