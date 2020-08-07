pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GLXToken is Ownable, ERC20 {

    address public router;

    modifier onlyRouter() {
        require(router == _msgSender(), "Router: ONLY_ROUTER");
        _;
    }

    constructor() public ERC20("GLXToken", "GLX") {
    }

    // 当被factory创建后就会调用一次init
    function initialize( address _newOwner)  external onlyOwner {
        transferOwnership(_newOwner);
    }

    function setRouter(address _router) public onlyOwner {
        router = _router;
    }

    function mint(address receiver, uint amount) public onlyRouter {
        _mint(receiver, amount);
    }

    function burn(uint amount) public onlyRouter {
        _burn(msg.sender, amount);
    }
}
