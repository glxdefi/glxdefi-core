pragma solidity ^0.6.0;

interface IGLXFactory {

    event GameGreated(address token, bool isOnChainGame);

    function createGame(address token, bool isOnChainGame) external returns (address game);

    function setRouter(address) external;

    function setFeeTo(address) external;
}
