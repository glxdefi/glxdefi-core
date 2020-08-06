pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

import "./interface/IGLXGame.sol";
import "./library/GLXHelper.sol";
import "./Lifecycle.sol";

contract GLXGame is IGLXGame, Lifecycle{

    using SafeMath for uint256;

    address public factory;
    address public router;

    bool public isOnlineGame;
    bool public gameResult;

    uint256 public trueTotalAmount;
    uint256 public falseTotalAmount;
    uint256 public trueTotalCount;
    uint256 public falseTotalCount;

    mapping (address => uint256) public trueAmountMap;
    mapping (address => uint256) public falseAmountMap;

    mapping (address => bool) public receivedMap;

    address public maxAmount;
    address public maxAmountAccount;
    address public interestIncome;

    constructor() public {
        factory = msg.sender;
        isOnlineGame = true;
    }

    // called once by the factory at time of deployment
    function initialize(address _router) external {
        require(msg.sender == factory, 'GLXGame: FORBIDDEN'); // sufficient check
        router = _router;
    }

    modifier onlyRouter() {
        require(msg.sender == router, 'GLXGame: FORBIDDEN'); // sufficient check
        _;
    }


    function bet(address account, bool direction, uint256 amount) public whenNotStarted onlyRouter returns (bool) {
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

    function receive(address account) public whenEnded returns (bool) {
        require(account != address(0), "GLXGame: RECEIVE_ADDRESS_ZERO");
        require(!receivedMap[account], "GLXGame: RECEIVED");

        require(trueTotalAmount != 0, "GLXGame: TRUE_TOTAL_AMOUNT_ZERO");
        require(falseTotalAmount != 0, "GLXGame: FALSE_TOTAL_AMOUNT_ZERO");

        if (gameResult) {
            require(trueAmountMap[account] != 0, "GLXGame: NOT_EXIST");

            uint64 receiveAmount = GLXHelper.calReceiveAmount(trueAmountMap[account], trueTotalAmount, falseTotalAmount);
            GLXHelper.safeTransfer(account, receiveAmount);

            receivedMap[account] = true;

        } else {
            require(falseAmountMap[account] != 0, "GLXGame: NOT_EXIST");

            uint64 receiveAmount = GLXHelper.calReceiveAmount(falseAmountMap[account], falseTotalAmount, trueTotalAmount);
            GLXHelper.safeTransfer(account, receiveAmount);

            receivedMap[account] = true;
        }

        if (account == maxAmountAccount) {
            GLXHelper.safeTransfer(account, interestIncome);
        }


        return true;
    }




}
