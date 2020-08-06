pragma solidity ^0.6.0;

import "./interface/IGLXFactory.sol";
import "./GLXGame.sol";

contract GLXFactory is IGLXFactory, Ownable {

    address public feeTo;
    address public router;


    function createGame(address extToken, bool isOnChainGame) external returns (address game) {
        //创建游戏合约
        bytes memory bytecode = type(GLXGame).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0));

        assembly {
            game := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IGLXGame(game).initialize(router);

        if (IGLXRouter(router).getIntToken[extToken] == address(0)) {
            //创建外部代币对应的内部代币合约
            bytes memory bytecode = type(GLXToken).creationCode;
            bytes32 salt = keccak256(abi.encodePacked(extToken));

            assembly {
                intToken := create2(0, add(bytecode, 32), mload(bytecode), salt)
            }

            GLXToken(intToken).setRouter(router);
            IGLXRouter(router).addIntToken(extToken, intToken);
            IGLXRouter(router).addGameExtToken(game, extToken);
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
