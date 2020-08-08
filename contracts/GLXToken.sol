pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GLXToken is Ownable, ERC20 {

    address public router;

    address public extToken;

    modifier onlyRouter() {
        require(router == _msgSender(), "GLXToken: ONLY_ROUTER");
        _;
    }

    constructor(address _router, address _extToken) public ERC20("GLXTokenOfHope", "HOPE") {
        router = _router;
        extToken = _extToken;
    }

    function setRouter(address _router) public onlyOwner {
        router = _router;
    }

    function mint(address receiver, uint256 amount) public onlyRouter {
        _mint(receiver, amount);
    }


    function burn(uint256 amount) public {
        require(amount > 0, "GLXToken: AMOUNT_IS_ZERO");

        uint256 swapAmount = _calSwapAmount(amount);
        require(swapAmount > 0, "GLXToken: SWAP_AMOUNT_IS_ZERO");

        _burn(msg.sender, amount);
        IERC20 dai = IERC20(extToken);
        dai.transfer(msg.sender, swapAmount);
    }

    function _calSwapAmount(uint256 amount) private view returns (uint256) {
        IERC20 dai = IERC20(extToken);
        return dai.balanceOf(msg.sender).mul(amount).div(totalSupply());
    }
}
