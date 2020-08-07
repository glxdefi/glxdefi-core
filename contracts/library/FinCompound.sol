pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../third-contract/compound/ICErc20.sol";

//compound 提交、赎回工具
library FinCompound {

    //提交token到compound
    //token: erc20 token地址
    //receiver: compound的接收合约地址  和token是一一对应的 cerc20
    //amount: 数量
    function supply(address token, address receiver, uint256 amount) public returns (uint) {
        require(amount > 0);

        IERC20 underlying = IERC20(token);
        ICErc20 cToken = ICErc20(receiver);

        underlying.approve(receiver, amount);

        uint mintResult = cToken.mint(amount);
        return mintResult;
    }

    //从compound赎回全部token
    //token: erc20 token地址
    //from: compound的合约地址  和token是一一对应的 cerc20
    //返回赎回的token数量
    function redeem(address token, address from) public returns (uint256) {
        IERC20 underlying = IERC20(token);
        ICErc20 cToken = ICErc20(from);
        uint256 amount = cToken.balanceOf(from);
        uint256 redeemResult = cToken.redeem(amount);

        return underlying.balanceOf(msg.sender);
    }
}
