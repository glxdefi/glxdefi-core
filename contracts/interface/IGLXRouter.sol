pragma solidity ^0.4.0;

interface IGLXRouter {

    function addIntToken(address extToken, address intToken) external;

    function addGameExtToken(address game, address extToken) external;

    function setFactory(address _factory) external;
}
