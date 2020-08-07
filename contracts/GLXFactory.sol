pragma solidity ^0.6.0;

import "./interface/IGLXFactory.sol";
import "./GLXGame.sol";
import "./GLXToken.sol";

contract GLXFactory is Ownable {


    address public feeTo;
    address public router;

    //GLXGame => DAI
    mapping(address => address) public getGameExtToken;
    //DAI  => gDAI
    mapping(address => address) public getIntToken;
    //gDAI  => liquidPool
    mapping(address => address) public getLiquidPool;


    constructor() public {
        feeTo = msg.sender;
    }


    //创建游戏合约，当游戏合于对应的代币没有创建是，还会自动创建代币
    function createGame(
        address extToken,
        address finToken,

        uint startBlockNumber,
        uint endBLockNumber,
        bool isOnChainGame,
        address gameObjectToken,
        uint256 gameObjectTokenSupply
) external returns (address game) {

        require(extToken != address(0), 'GLXFactory: TOKEN_INVALID');

        game = _createGame(extToken, finToken, startBlockNumber, endBLockNumber, isOnChainGame, gameObjectToken, gameObjectTokenSupply);
        getGameExtToken[game] = extToken;

        if (getIntToken[extToken] == address(0)) {
            //创建外部代币对应的内部代币合约
            address intToken = _createIntToken(extToken);
            getIntToken[extToken] = intToken;
        }

        return game;
    }

    function _createGame(
        address extToken,
        address finToken,
        uint startBlockNumber,
        uint endBLockNumber,
        bool isOnChainGame,
        address gameObjectToken,
        uint256 gameObjectTokenSupply
    ) private returns (address game){

        //创建游戏合约
        bytes memory bytecode = type(GLXGame).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(extToken));
        assembly {
            game := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        //初始化游戏合约参数
        IGLXGame(game).initialize(router, extToken, finToken, startBlockNumber, endBLockNumber, isOnChainGame, gameObjectToken, gameObjectTokenSupply);

        return game;
    }

    function _createIntToken(address extToken) private returns (address intToken){
        bytes memory bytecode = type(GLXToken).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(extToken));

        assembly {
            intToken := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        //之所以没有把router放到initialize中是为了加入router有变更，需要重新set，而initialize通常只能调用一次
        GLXToken(intToken).setRouter(router);
        //将部署合约地址设置为token的owner；之所以放到后面，是因为setRouter需要factory作为owner才能操作
        GLXToken(intToken).initialize(msg.sender, extToken);

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
