pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//DAI对应的平台代币,没有owner，平台资金全部归属股东
contract GLXToken is ERC20 {

    //router地址
    address public router;

    //外部token，如DAI
    address public extToken;

    //只能router能铸币
    modifier onlyRouter() {
        require(router == _msgSender(), "GLXToken: ONLY_ROUTER");
        _;
    }

    constructor(address _router, address _extToken) public ERC20("GLXTokenOfHope", "HOPE") {
        router = _router;
        extToken = _extToken;
    }

    //铸币，只能当用户押注的时候，由router根据DAI的数量，逐步递减的 发起铸币
    function mint(address receiver, uint256 amount) public onlyRouter {
        _mint(receiver, amount);
    }


    //股东可以随时领取自身权益，领取后，平台代币自动销毁
    function burn(uint256 amount) public {
        require(amount > 0, "GLXToken: AMOUNT_IS_ZERO");

        //根据平台代币和DAI的比例，计算出amount数量的平台代币，可以换多少DAI
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
