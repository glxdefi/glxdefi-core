pragma solidity ^0.6.0;

interface IGLXFactory {

    event GameCreated(address token, uint startBlockNumber, uint endBLockNumber, bool isOnChainGame);

    function createGame(address token, uint startBlockNumber, uint endBLockNumber, bool isOnChainGame) external returns (address game);

    function setRouter(address) external;

    function setFeeTo(address) external;
}
