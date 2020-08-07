
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/GSN/Context.sol";


abstract contract GLXLifecycle is Context {

    uint private startBlockNumber;

    uint private endBlockNumber;


    constructor (uint _startBlockNumber, uint _endBlockNumber ) internal {
        require(_startBlockNumber < _endBlockNumber, "GLXLifecycle: BLOCK_NUMBER_INVALID");
        require(_startBlockNumber > block.number, "GLXLifecycle: BLOCK_NUMBER_INVALID");

        startBlockNumber = _startBlockNumber;
        endBLockNumber = _endBlockNumber;
    }


    function isStarted() public view returns (bool) {
        if(block.number >= startBlockNumber) {
            return true;
        }
        return false;
    }


    function isEnded() public view returns (bool) {
        if(block.number > endBLockNumber) {
            return true;
        }
        return false;
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


}
