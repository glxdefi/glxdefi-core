pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

import "./interface/IGLXGame.sol";
import "./interface/IGLXFactory.sol";
import "./abstract/GLXLifecycle.sol";
import "./library/GLXHelper.sol";
import "./library/CompoundHelper.sol";


//game合约：游戏实例，可以同时创建不同代币参与，以及不同时间维度和不同对赌标的的游戏
//为了公信力，废弃owner角色
contract GLXGame is GLXLifecycle{

    using SafeMath for uint256;

    //股东抽成抽成比例，默认3%个点
    uint256 public constant SHARE_HOLDER_RAKE_RATE = 3;

    //factory 地址
    address public factory;
    //router 地址
    address public router;

    //押注的token
    address public extToken;
    //内部股东权益token
    address public intToken;
    //理财合约地址token
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

    //押注资金最大额度
    uint256 public maxAmount;
    //押注资金最大额度的用户地址
    address public maxAmountAccount;

    //compound 利息总收入
    uint256 public interestIncome;
    //股东总收益3%
    uint256 public shareHolderProfit;
    //赢方收益97%：falseTotalAmount - shareHolderProfit 或者 trueTotalAmount - shareHolderProfit
    uint256 public winPrincipalProfit;

    //防止重入攻击
    uint8 private unlocked = 1;


    //押注事件
    event Bet(address account, bool direction, uint256 amount);
    //领取收益事件
    event ReceiveIncome(address account);
    //开奖事件
    event UpdateGameResult();
    //通过oracle开奖事件
    event UpdateGameResultByOracle(uint8 _gameResult);

    constructor() public {
        factory = msg.sender;
    }

    // 当被factory创建后就会调用一次init
    function initialize(
        address _router,//router地址
        address _extToken,//外部押注代币，如DAI
        address _intToken,//内部发行代币，如gDAI
        address _finToken,//defi生息地址

        uint _startBlockNumber,//游戏开始高度
        uint _endBlockNumber,//游戏开奖高度
        bool _isOnChainGame,//是否是以链上数据来做对赌标的游戏
        address _gameObjectToken,//当是链上标的地址
        uint256 _gameObjectTokenSupply//标的数据指标值
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
        require(isCanReceive(), 'GLXGame: NOT_CAN_RECEIVE');
        _;
    }



    //是否可以领取收益了
    function isCanReceive() public view returns (bool) {
        if (!isEnded()) {
            return false;
        }

        if(!isGameResultOpen) {
            return false;
        }

        return true;
    }



    //查看自己是否拥有需要提取的收益
    function isExistIncomeNeedReceive(address account) external view returns (bool) {
        if (!isCanReceive()) {
            return false;
        }

        if ((trueAmountMap[account] > 0) && gameResult) {
                return true;
        }

        if ((falseAmountMap[account] > 0) && !gameResult) {
            return true;
        }

        if ((trueAmountMap[account] > 0) && !gameResult && (falseTotalAmount == 0)) {
            return true;
        }

        if ((falseAmountMap[account] > 0) && gameResult && (trueTotalAmount == 0)) {
            return true;
        }


        if (account == maxAmountAccount) {
            return true;
        }

        return false;
    }

    // 押注
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

        emit Bet(account, direction, amount);

        return true;
    }

    //领取收益
    function receiveIncome(address _account) external lock whenCanReceive returns (bool) {
        require(_account != address(0), "GLXGame: RECEIVE_ADDRESS_ZERO");
        require(!isReceivedMap[_account], "GLXGame: RECEIVED");

        //押注链下数据 需要oracle结果
        require(isGameResultOpen, "GLXGame: GAME_NOT_START_GET_INCOME");

        require(trueTotalAmount != 0 || falseTotalAmount != 0, "GLXGame: NOBODY_BET");


        uint256 receiveAmount = 0;

        //计算
        if (gameResult) {
            //正方赢
            if (trueAmountMap[_account] > 0) {
                //押中正方
                receiveAmount = GLXHelper.calReceiveAmount(trueAmountMap[_account], trueTotalAmount, winPrincipalProfit);

            } else if ((trueTotalAmount == 0) && (falseAmountMap[_account] > 0)) {
                //正方赢，但是没人押正方，需要退还反方的97%本金
                receiveAmount = GLXHelper.calReceiveAmount(falseAmountMap[_account], falseTotalAmount, winPrincipalProfit);
            }

        } else {
            //反方赢
            if (falseAmountMap[_account] > 0) {
                //押中反方
                receiveAmount = GLXHelper.calReceiveAmount(falseAmountMap[_account], falseTotalAmount, winPrincipalProfit);

            } else if ((falseTotalAmount == 0) && (trueAmountMap[_account] > 0)) {
                //反方赢，但是没人押反方，需要退还正方的97%本金
                receiveAmount = GLXHelper.calReceiveAmount(trueAmountMap[_account], trueTotalAmount, winPrincipalProfit);
            }
        }

        if (_account == maxAmountAccount) {
            //如果是押注本金最大的，可以独享 全额利息收益
            receiveAmount = receiveAmount.add(interestIncome);
        }

        if(receiveAmount > 0) {
            GLXHelper.safeTransfer(extToken, _account, receiveAmount);

            isReceivedMap[_account] = true;
        }

        emit ReceiveIncome(_account);
        return true;
    }

    //将平台抽成赚到全部收益 分给持有平台币的股东
    function _transferProfit2ShareHolder() private {
        if (gameResult) {
            shareHolderProfit = falseTotalAmount.mul(SHARE_HOLDER_RAKE_RATE).div(uint256(100));
            //一次性算出来之后，在提取收益的时候就不用重复去算了
            winPrincipalProfit = falseTotalAmount.sub(shareHolderProfit);
        } else {
            shareHolderProfit = trueTotalAmount.mul(SHARE_HOLDER_RAKE_RATE).div(uint256(100));
            winPrincipalProfit = trueTotalAmount.sub(shareHolderProfit);
        }

        if (winPrincipalProfit > 0) {
            GLXHelper.safeTransfer(extToken, intToken, shareHolderProfit);
        }
    }

    //清算各方收益:包括赢家，持有平台币的股东，以及本局最大投注人收益
    function _clearProfit() private {

        uint256 totalAmount = CompoundHelper.redeem(extToken,  finToken);
        uint256 initAmount = trueTotalAmount.add(falseTotalAmount);

        require(totalAmount >= initAmount, "GLXGame: FIN_INCOME_INVALID");

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

        emit UpdateGameResult();

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

        emit UpdateGameResultByOracle(_gameResult);

        return true;
    }

    function getIncomeAmount(address _account) external view returns (uint256) {
        require(_account != address(0), "GLXGame: RECEIVE_ADDRESS_ZERO");

        //押注链下数据 需要oracle结果
        require(isGameResultOpen, "GLXGame: GAME_NOT_START_GET_INCOME");

        uint256 receiveAmount = 0;

        if ((trueTotalAmount == 0) && (falseTotalAmount != 0)) {
            return receiveAmount;
        }



        //计算
        if (gameResult) {
            //正方赢
            if (trueAmountMap[_account] > 0) {
                //押中正方
                receiveAmount = GLXHelper.calReceiveAmount(trueAmountMap[_account], trueTotalAmount, winPrincipalProfit);

            } else if ((trueTotalAmount == 0) && (falseAmountMap[_account] > 0)) {
                //正方赢，但是没人押正方，需要退还反方的97%本金
                receiveAmount = GLXHelper.calReceiveAmount(falseAmountMap[_account], falseTotalAmount, winPrincipalProfit);
            }

        } else {
            //反方赢
            if (falseAmountMap[_account] > 0) {
                //押中反方
                receiveAmount = GLXHelper.calReceiveAmount(falseAmountMap[_account], falseTotalAmount, winPrincipalProfit);

            } else if ((falseTotalAmount == 0) && (trueAmountMap[_account] > 0)) {
                //反方赢，但是没人押反方，需要退还正方的97%本金
                receiveAmount = GLXHelper.calReceiveAmount(trueAmountMap[_account], trueTotalAmount, winPrincipalProfit);
            }
        }

        if (_account == maxAmountAccount) {
            //如果是押注本金最大的，可以独享 全额利息收益
            receiveAmount = receiveAmount.add(interestIncome);
        }

        return receiveAmount;

    }

        //获取总参加人数
    function getCurUserCount() external view returns (uint256) {
        return trueTotalCount.add(falseTotalCount);
    }
}
