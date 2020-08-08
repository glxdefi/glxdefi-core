pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./interface/IGLXRouter.sol";
import "./interface/IGLXFactory.sol";
import "./interface/IGLXGame.sol";

import "./library/GLXHelper.sol";

//router合约：主要功能是作为游戏的入口
//此处合约owner只能用户oracle喂数据，不能修改游戏逻辑
contract GLXRouter is Ownable {

    using SafeMath for uint256;


    //代币铸币的时候其中多少比例放到流动性挖矿池子中提供利息，默认60%个点，其余40%直接发给平台股东
    uint256 public constant LIQUID_MINT_RATE = 60;

    //factory地址
    address public factory;


    constructor(address _factory) public {
        require(_factory != address(0), 'GLXRouter: ADDRESS_NULL');

        factory = _factory;
    }

    //校验游戏地址是否合法
    modifier validGame(address game) {
        require(game != address(0), 'GLXRouter: GAME_INVALID');
        require(IGLXFactory(factory).getGameExtToken(game) != address(0), 'GLXRouter: GAME_NOT_EXIST');
        _;
    }

    // 押注
    function bet(
        address game,
        bool direction,
        uint256 amount
    ) external validGame(game) returns (bool) {
        address extToken = IGLXFactory(factory).getGameExtToken(game);
        require( extToken != address(0), 'GLXRouter: GAME_EXT_TOKEN_NOT_MATCH');

        address intToken = IGLXFactory(factory).getIntToken(extToken);
        require(intToken != address(0), 'GLXRouter: INT_TOKEN_NOT_EXIST');


        //将用户的押注token 转到game合约
        GLXHelper.safeTransferFrom(extToken, msg.sender, game, amount);

        //押注的同时将会铸币，会将这部分 平台代币分 40% 给用户,60%转到流动性挖矿pool里做利息
        _mint(game, intToken, amount);

        //调用game合约，触发登记 以及 将押注token 拿去defi生息
        require(IGLXGame(game).bet(msg.sender, direction, amount), 'GLXRouter: GAME_BET_FAILED');

        return true;
    }

    //押注的同时将会铸币，会将这部分 平台代币分 40% 给用户,60%转到流动性挖矿pool里做利息
    function _mint(address game, address intToken, uint256 amount) internal returns (bool) {
        //获取当前已经有多少人参与游戏
        uint256 curUserCount = IGLXGame(game).getCurUserCount();

        uint256 discount = IGLXFactory(factory).getMintDiscount(intToken);
        //同样的押注资金：在同一个epoch中，越早押注铸币越多。在不同epoch中，同一个押注次序，早期的epoch会收获更多的代币,公式：100 * amount / ( (turnNumber / 10)  + 1)  / discount
        uint256 totalMintAmount = amount.div( (uint256(1).add(curUserCount.div(uint256(10))) )).mul(uint256(100)).div(discount);

        uint256 liquidMintAmount = totalMintAmount.mul(LIQUID_MINT_RATE).div(uint256(100));
        uint256 userMintAmount = totalMintAmount.sub(liquidMintAmount);

        //为股东铸币
        GLXHelper.safeMint(intToken, msg.sender, userMintAmount);

        //为流动性池子铸币
        address liquidPool = IGLXFactory(factory).getLiquidPool(intToken);
        GLXHelper.safeMint(intToken, liquidPool, liquidMintAmount);


        return true;
    }

    // 用户自行领奖：减少平台发奖成本开销
    function receiveIncome(address game) external validGame(game) returns (bool) {

        require(IGLXGame(game).receiveIncome(msg.sender), 'GLXRouter: GAME_RECEIVE_FAILED');

        return true;
    }

    //当对赌的标的 是链上数据，需要触发开奖
    function updateGameResult(address game) external validGame(game) returns (bool) {

        require(IGLXGame(game).updateGameResult(), 'GLXRouter: GAME_UPDATE_RESULT_FAILED');

        return true;
    }

    //当对赌的标的 是链下数据，需要oracle喂结果;防止缺省值影响，2代表true正方赢， 1代表false 反方赢，
    function updateGameResultByOracle(address game, uint8 gameResult) external onlyOwner validGame(game) returns (bool) {

        require(IGLXGame(game).updateGameResultByOracle(gameResult), 'GLXRouter: GAME_ORACLE_FAILED');

        return true;
    }

}
