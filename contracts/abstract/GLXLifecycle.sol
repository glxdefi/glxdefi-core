
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/GSN/Context.sol";


//game的生命周期状态内
 contract GLXLifecycle is Context {

    uint public startBlockNumber;

    uint public endBlockNumber;


     //初始化游戏起始高度，结束高度
    function _initBlockNumber(uint _startBlockNumber, uint _endBlockNumber)  internal  {
        require(startBlockNumber == 0 && endBlockNumber == 0, "GLXLifecycle: BLOCK_NUMBER_ALREADY_INIT");
        require(_startBlockNumber < _endBlockNumber, "GLXLifecycle: BLOCK_NUMBER_INVALID");
        require(_startBlockNumber > block.number, "GLXLifecycle: BLOCK_NUMBER_INVALID");

        startBlockNumber = _startBlockNumber;
        endBlockNumber = _endBlockNumber;
    }

     //游戏是否已经开始
    function isStarted() public view returns (bool) {
        if(block.number >= startBlockNumber) {
            return true;
        }
        return false;
    }


     //游戏是否已经开奖了
    function isEnded() public view returns (bool) {
        if(block.number > endBlockNumber) {
            return true;
        }
        return false;
    }


}
