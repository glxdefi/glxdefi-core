pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

import "./interface/IGLXGame.sol";
import "./library/GLXHelper.sol";
import "./abstract/GLXLifecycle.sol";

contract GLXGame is IGLXGame, GLXLifecycle, Ownable{

    using SafeMath for uint256;

    address public factory;
    address public router;

    //对赌标的是否是链上数据：true代表是 链上数据，false代表是 链下数据
    bool public isOnChainGame;
    bool public isOffChainOracled;

    //游戏输赢结果，true 表示 正方赢，false表示反方赢
    bool public gameResult;

    //正方总押注额度
    uint256 public trueTotalAmount;
    //反方总押注额度
    uint256 public falseTotalAmount;
    //正方总参与人数
    uint public trueTotalCount;
    //反方总参与人数
    uint public falseTotalCount;

    //正方押注额度
    mapping (address => uint256) public trueAmountMap;
    //反方押注额度
    mapping (address => uint256) public falseAmountMap;

    //领奖状态：false表示未领取，true表示已经领取
    mapping (address => bool) public isReceivedMap;

    address public maxAmount;
    address public maxAmountAccount;
    address public interestIncome;

    constructor(uint _startBlockNumber, uint _endBlockNumber) GLXLifecycle(_startBlockNumber, _endBlockNumber) public {
        factory = msg.sender;
        isOnlineGame = true;
    }

    // called once by the factory at time of deployment
    function initialize(address _router, address _token) external {
        require(msg.sender == factory, 'GLXGame: FORBIDDEN'); // sufficient check
        router = _router;
    }

    modifier onlyRouter() {
        require(msg.sender == router, 'GLXGame: FORBIDDEN'); // sufficient check
        _;
    }

    //防止重入攻击
    modifier lock() {
        require(unlocked == 1, 'GLXGame: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    function bet(address account, bool direction, uint256 amount) external lock whenNotStarted onlyRouter returns (bool) {
        require(account != address(0), "GLXGame: BET_ADDRESS_ZERO");
        require(amount > 0, "GLXGame: BET_AMOUNT_ZERO");

        if (direction) {
            trueTotalAmount = trueTotalAmount.add(amount);
            trueTotalCount = trueTotalCount.add(1);
            trueAmountMap[account] = trueAmountMap[account].add(amount);
            if (trueAmountMap[account] > maxAmount){
                maxAmount = trueAmountMap[account];
                maxAmountAccount = account;
            }
        } else {
            falseTotalAmount = falseTotalAmount.add(amount);
            falseTotalCount = falseTotalCount.add(1);
            falseAmountMap[account] = falseAmountMap[account].add(amount);
            if (falseAmountMap[account] > maxAmount){
                maxAmount = falseAmountMap[account];
                maxAmountAccount = account;
            }
        }


        return true;
    }

    function receive(address _account) external lock whenEnded returns (bool) {
        require(_account != address(0), "GLXGame: RECEIVE_ADDRESS_ZERO");
        require(!isReceivedMap[_account], "GLXGame: RECEIVED");

        require(trueTotalAmount != 0, "GLXGame: TRUE_TOTAL_AMOUNT_ZERO");
        require(falseTotalAmount != 0, "GLXGame: FALSE_TOTAL_AMOUNT_ZERO");

        //押注链下数据 需要oracle结果
        require(isOnChainGame || isOffChainOracled, "GLXGame: OFF_CHAIN_GAME_NOT_ORACLE");


        if (gameResult) {
            require(trueAmountMap[_account] != 0, "GLXGame: NOT_EXIST");

            uint64 receiveAmount = GLXHelper.calReceiveAmount(trueAmountMap[_account], trueTotalAmount, falseTotalAmount);
            GLXHelper.safeTransfer(_account, receiveAmount);

            isReceivedMap[_account] = true;

        } else {
            require(falseAmountMap[_account] != 0, "GLXGame: NOT_EXIST");

            uint64 receiveAmount = GLXHelper.calReceiveAmount(falseAmountMap[_account], falseTotalAmount, trueTotalAmount);
            GLXHelper.safeTransfer(_account, receiveAmount);

            isReceivedMap[_account] = true;
        }

        if (_account == maxAmountAccount) {
            GLXHelper.safeTransfer(_account, interestIncome);
        }


        return true;
    }



    //当对赌的标的 是链下数据，需要oracle喂结果
    function updateGameResultByOracle(bool _direction) external lock onlyRouter whenEnded returns (bool) {

        //押注链下数据 需要oracle结果
        require(!isOnChainGame, "GLXGame: NOT_OFF_CHAIN_GAME");
        require(!isOffChainOracled, "GLXGame: ALREADY_ORACLED");

        isOffChainOracled = true;
        direction = _direction;

        return true;
    }

}
