
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/GSN/Context.sol";


abstract contract Lifecycle is Context {

    event Started(address account);

    event End(address account);


    bool private _started;

    bool private _ended;


    constructor () internal {
        _started = false;
        _ended = false;
    }


    function started() public view returns (bool) {
        return _started;
    }


    function ended() public view returns (bool) {
        return _ended;
    }


    modifier whenNotStarted() {
        require(!_started, "Start: started");
        _;
    }
    modifier whenStarted() {
        require(_started, "Start: not started");
        _;
    }


    modifier whenNotEnded() {
        require(!_ended, "End: ended");
        _;
    }
    modifier whenEnded() {
        require(_ended, "End: not ended");
        _;
    }


    function _start() internal virtual whenNotStarted {
        _started = true;
        emit Started(_msgSender());
    }

    function _end() internal virtual whenNotEnded {
        _ended = true;
        emit End(_msgSender());
    }

}
