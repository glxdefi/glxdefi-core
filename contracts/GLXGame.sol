pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

import "./interface/IGLXGame.sol";
import "./interface/IGLXFactory.sol";
import "./abstract/GLXLifecycle.sol";
import "./library/GLXHelper.sol";
import "./library/CompoundHelper.sol";



contract GLXGame is GLXLifecycle{

    using SafeMath for uint256;

    address public factory;
    address public router;
    address public extToken;
    address public intToken;
    address public finToken;


    //对赌标的是否是链上数据：true代表是 链上数据，false代表是 链下数据
    bool public isOnChainGame;
    //游戏结果是否已经揭晓
    bool public isGameResultOpen;

    //游戏对赌标的token，如DAI
    address public gameObjectToken;
    //对赌标的的目标发行量，到开奖时，实际只大等于这个值，则表示正方赢；否则反方赢
    uint256 public gameObjectTokenSupply;


    //游戏输赢结果，true 表示 正方赢，false表示反方赢
    bool public gameResult;

    //正方总押注额度
    uint256 public trueTotalAmount;
    //反方总押注额度
    uint256 public falseTotalAmount;
    //正方总参与人数
    uint256 public trueTotalCount;
    //反方总参与人数
    uint256 public falseTotalCount;

    //正方押注额度
    mapping (address => uint256) public trueAmountMap;
    //反方押注额度
    mapping (address => uint256) public falseAmountMap;

    //领奖状态：false表示未领取，true表示已经领取
    mapping (address => bool) public isReceivedMap;

    uint256 public maxAmount;
    address public maxAmountAccount;

    //利息总收入
    uint256 public interestIncome;
    //股东收益
    uint256 public shareHolderProfit;
    //赢方收益：falseTotalAmount - shareHolderProfit 或者 trueTotalAmount - shareHolderProfit
    uint256 public winPrincipalProfit;


    uint8 private unlocked = 1;
    constructor() public {
        factory = msg.sender;
    }

    // 当被factory创建后就会调用一次init
    function initialize(
        address _router,
        address _extToken,
        address _intToken,
        address _finToken,

        uint _startBlockNumber,
        uint _endBlockNumber,
        bool _isOnChainGame,
        address _gameObjectToken,
        uint256 _gameObjectTokenSupply
    )  external onlyFactory {

        router = _router;
        extToken = _extToken;
        intToken = _intToken;
        finToken = _finToken;

        _initBlockNumber(_startBlockNumber, _endBlockNumber);

        isOnChainGame = _isOnChainGame;

        //如果为链下数据，后面两个参数缺省为0
        gameObjectToken = _gameObjectToken;
        gameObjectTokenSupply = _gameObjectTokenSupply;

    }

    //防止重入攻击
    modifier lock() {
        require(unlocked == 1, 'GLXGame: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    modifier onlyRouter() {
        require(msg.sender == router, 'GLXGame: FORBIDDEN');
        _;
    }

    modifier onlyFactory() {
        require(msg.sender == factory, 'GLXGame: FORBIDDEN');
        _;
    }

    modifier whenNotStarted() {
        require(!isStarted(), "Start: started");
        _;
    }
    modifier whenStarted() {
        require(isStarted(), "Start: not started");
        _;
    }


    modifier whenNotEnded() {
        require(!isEnded(), "End: ended");
        _;
    }

    modifier whenEnded() {
        require(isEnded(), "End: not ended");
        _;
    }

    //是否可以领取收益了
    modifier whenCanReceive() {
        require(!isCanReceive(), 'GLXGame: NOT_CAN_RECEIVE');
        _;
    }



    function isCanReceive() public view returns (bool) {
        if (!isEnded()) {
            return false;
        }

        if(!isGameResultOpen) {
            return false;
        }

        return true;
    }



    //查看是否拥有需要提取的收益
    function isExistBonusNeedReceive() public view returns (bool) {
        if (!isCanReceive()) {
            return false;
        }

        if ((trueAmountMap[msg.sender] > 0) && gameResult) {
                return true;
        }

        if ((falseAmountMap[msg.sender] > 0) && !gameResult) {
            return true;
        }

        if (msg.sender == maxAmountAccount) {
            return true;
        }

        return false;
    }


    function bet(address account, bool direction, uint256 amount) external lock whenNotStarted onlyRouter returns (bool) {
        require(account != address(0), "GLXGame: BET_ADDRESS_ZERO");
        require(amount > 0, "GLXGame: BET_AMOUNT_ZERO");

        if (direction) {
            //押注正方，登记金额
            trueTotalAmount = trueTotalAmount.add(amount);
            trueTotalCount = trueTotalCount.add(1);
            trueAmountMap[account] = trueAmountMap[account].add(amount);
            if (trueAmountMap[account] > maxAmount){
                maxAmount = trueAmountMap[account];
                maxAmountAccount = account;
            }
        } else {
            //押注反方，登记金额
            falseTotalAmount = falseTotalAmount.add(amount);
            falseTotalCount = falseTotalCount.add(1);
            falseAmountMap[account] = falseAmountMap[account].add(amount);
            if (falseAmountMap[account] > maxAmount){
                maxAmount = falseAmountMap[account];
                maxAmountAccount = account;
            }
        }

        CompoundHelper.supply(extToken,  finToken, amount);

        return true;
    }

    //领取收益
    function getIncome(address _account) external lock whenCanReceive returns (bool) {
        require(_account != address(0), "GLXGame: RECEIVE_ADDRESS_ZERO");
        require(!isReceivedMap[_account], "GLXGame: RECEIVED");

        require(trueTotalAmount != 0, "GLXGame: TRUE_TOTAL_AMOUNT_ZERO");
        require(falseTotalAmount != 0, "GLXGame: FALSE_TOTAL_AMOUNT_ZERO");

        //押注链下数据 需要oracle结果
        require(isGameResultOpen, "GLXGame: 还没有开奖");

        uint256 receiveAmount = 0;

        //计算
        if (gameResult) {
            require(trueAmountMap[_account] != 0, "GLXGame: NOT_EXIST");

            receiveAmount = GLXHelper.calReceiveAmount(trueAmountMap[_account], trueTotalAmount, winPrincipalProfit);
        } else {
            require(falseAmountMap[_account] != 0, "GLXGame: NOT_EXIST");

            receiveAmount = GLXHelper.calReceiveAmount(falseAmountMap[_account], falseTotalAmount, winPrincipalProfit);
        }

        if (_account == maxAmountAccount) {
            //如果是押注本金最大的，可以独享 全额利息收益
            receiveAmount = receiveAmount.add(interestIncome);
        }

        if(receiveAmount > 0) {
            GLXHelper.safeTransfer(extToken, _account, receiveAmount);

            isReceivedMap[_account] = true;
        }

        return true;
    }

    //将平台抽成赚到全部收益 分给持有平台币的股东
    function _transferProfit2ShareHolder() private {
        if (gameResult) {
            shareHolderProfit = falseTotalAmount.mul(uint256(3)).div(uint256(100));
            //一次性算出来之后，在提取收益的时候就不用重复去算了
            winPrincipalProfit = falseTotalAmount.sub(shareHolderProfit);
        } else {
            shareHolderProfit = trueTotalAmount.mul(uint256(3)).div(uint256(100));
            winPrincipalProfit = trueTotalAmount.sub(shareHolderProfit);
        }
        GLXHelper.safeTransfer(extToken, intToken, shareHolderProfit);
    }

    //清算各方收益:包括赢家，持有平台币的股东，以及本局最大投注人收益
    function _clearProfit() private {

        uint256 totalAmount = CompoundHelper.redeem(extToken,  finToken);
        uint256 initAmount = trueTotalAmount.add(falseTotalAmount);

        require(totalAmount < initAmount, "GLXGame: FIN_INCOME_INVALID");

        interestIncome = totalAmount.sub(initAmount);


        //将平台抽成赚到全部收益 分给持有平台币的股东，股东可将平台代币burn掉的时候，就会收到股东权益
        _transferProfit2ShareHolder();


    }

    //当对赌的标的 是链上数据，需要触发开奖,谁都可以来开奖
    function updateGameResult() external lock whenEnded returns (bool) {

        //押注链上数据 需要oracle结果
        require(isOnChainGame, "GLXGame: NOT_ON_CHAIN_GAME");
        require(!isGameResultOpen, "GLXGame: GAME_RESULT_ALREADY_OPEN");

        if (IERC20(gameObjectToken).totalSupply() >= gameObjectTokenSupply) {
            gameResult = true;
        } else {
            gameResult = false;
        }

        //清算各方收益
        _clearProfit();

        //更新本局状态
        isGameResultOpen = true;

        return true;
    }



    //当对赌的标的 是链下数据，需要oracle喂结果;防止缺省值影响，2代表true正方赢， 1代表false 反方赢，
    function updateGameResultByOracle(uint8 _gameResult) external lock onlyRouter whenEnded returns (bool) {

        //押注链下数据 需要oracle结果
        require(!isOnChainGame, "GLXGame: NOT_OFF_CHAIN_GAME");
        require(!isGameResultOpen, "GLXGame: GAME_RESULT_ALREADY_ORACLED");
        require(_gameResult == 1 ||  _gameResult == 2, "GLXGame: gameResult不合法");


        if(_gameResult == 1) {
            gameResult = true;
        } else{
            gameResult = true;
        }

        //清算各方收益
        _clearProfit();

        //更新本局状态
        isGameResultOpen = true;

        return true;
    }

    //获取利率
    function getApr() external whenEnded returns (uint256) {
        return CompoundHelper.exchangeRate(finToken);
    }

    //获取总参加人数
    function getCurUserCount() external view returns (uint256) {
        return trueTotalCount.add(falseTotalCount);
    }
}
