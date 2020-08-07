pragma solidity ^0.6.0;

interface IGLXFactory {

    event GameCreated(address token, uint startBlockNumber, uint endBLockNumber, bool isOnChainGame);

    function createGame(
        address extToken,
        address finToken,

        uint startBlockNumber,
        uint endBLockNumber,
        bool isOnChainGame,
        address gameObjectToken,
        uint256 gameObjectTokenSupply
    )  external returns (address game);

    function setRouter(address) external;

    function setFeeTo(address) external;

    function getIntToken(address extToken) external view returns (address intToken);

    function getGameExtToken(address game) external view returns (address extToken);

}
