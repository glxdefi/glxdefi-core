pragma solidity ^0.4.0;

interface IGLXRouter {

    function addExtToken2IntToken(address extToken, address intToken) external;

    function setFactory(address _factory) external;
}
