pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GLXToken is Ownable, ERC20 {

    address public router;

    address public daiAddress;

    modifier onlyRouter() {
        require(router == _msgSender(), "Router: ONLY_ROUTER");
        _;
    }

    constructor(address _daiAddress) public ERC20("GLXToken", "GLX") {
        daiAddress = _daiAddress;
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

    function swap(uint amount) public {
        require(amount > 0);
        uint swapAmount = calSwapAmount(msg.sender, amount);
        require(swapAmount > 0);
        _burn(msg.sender, amount);
        IERC20 dai = IERC20(daiAddress);
        dai.transfer(msg.sender, swapAmount);
    }

    function calSwapAmount(address account, uint amount) internal returns (uint) {
        IERC20 dai = IERC20(daiAddress);
        return dai.balanceOf(msg.sender).mul(amount).div(totalSupply());
    }
}
