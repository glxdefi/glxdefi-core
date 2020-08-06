pragma solidity ^0.6.0;

import "./interface/IGLXFactory.sol";
import "./GLXGame.sol";

contract GLXFactory is IGLXFactory, Ownable {

    address public feeTo;
    address public router;


    function createGame(address extToken, bool isOnChainGame) external returns (address game) {
        bytes memory bytecode = type(GLXGame).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0));

        assembly {
            game := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IGLXGame(game).initialize(router);

        if (IGLXRouter(router).extToken2IntToken[token] == address(0)) {
            bytes memory bytecode = type(GLXToken).creationCode;
            bytes32 salt = keccak256(abi.encodePacked(token0));

            assembly {
                intToken := create2(0, add(bytecode, 32), mload(bytecode), salt)
            }

            GLXToken(intToken).setRouter(router);
            IGLXRouter(router).addExtToken2IntToken(extToken, intToken);
        }
    }


    function setRouter(address _router) external onlyOwner {
        require(_router != address(0), 'GLXFactory: ADDRESS_NULL');
        router = _router;
    }

    function setFeeTo(address _feeTo) external onlyOwner {
        require(_feeTo != address(0), 'GLXFactory: ADDRESS_NULL');
        feeTo = _feeTo;
    }
}
