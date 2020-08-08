pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "../third-contract/compound/ICErc20.sol";

//compound 提交、赎回工具
library CompoundHelper {

    using SafeMath for uint256;

    //提交token到compound
    //token: erc20 token地址
    //receiver: compound的接收合约地址  和token是一一对应的 cerc20
    //amount: 数量
    function supply(address token, address receiver, uint256 amount) public returns (bool) {
        require(amount > 0, "CompoundHelper: AMOUNT_IS_ZERO");

        IERC20 underlying = IERC20(token);
        ICErc20 cToken = ICErc20(receiver);

        underlying.approve(receiver, amount);

        require(cToken.mint(amount) == 0, "CompoundHelper: C_TOKEN_MINT_FAILED");
        return true;
    }

    //从compound赎回全部token
    //token: erc20 token地址
    //from: compound的合约地址  和token是一一对应的 cerc20
    //返回赎回的token数量
    function redeem(address token, address from) public returns (uint256) {
        ICErc20 cToken = ICErc20(from);

        //查询game持有cDAI的数量
        uint256 amount = cToken.balanceOf(address(this));
        require(cToken.redeem(amount) == 0, "CompoundHelper: REDEEM_RESULT_FAILED");

        //查询game持有DAI的数量
        IERC20 underlying = IERC20(token);
        return underlying.balanceOf(address(this));
    }

    //获取利率
    function exchangeRate(address ctoken) public returns (uint256) {
        ICErc20 cToken = ICErc20(ctoken);
        return cToken.exchangeRateCurrent();
    }
}
