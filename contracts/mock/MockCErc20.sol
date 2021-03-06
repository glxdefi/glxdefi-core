pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockCErc20 is Ownable {

    using SafeMath for uint256;

    mapping (address => uint256) public balanceOf;

    uint256 private ratio = 3;

    address public erc20Address;

    constructor(address _erc20Address) public {
        require(address(_erc20Address) != address(0));
        erc20Address = _erc20Address;
    }

    function mint(uint256 _amount) external returns (uint256) {
        require(_amount > 0);
        return mintInternal(_amount);
    }

    function mintInternal(uint256 mintAmount) internal returns (uint256) {
        IERC20 underlying = IERC20(erc20Address);
        underlying.transferFrom(msg.sender, address(this), mintAmount);
        balanceOf[msg.sender] += mintAmount;

        return uint256(0);
    }

    function exchangeRateCurrent() external view returns (uint256){
        return ratio;
    }

    function supplyRatePerBlock() external pure  returns (uint256){
        return uint256(0);
    }

    function redeem(uint256 _amount) external returns (uint256){
        require(_amount > 0);
        require(balanceOf[msg.sender] >= _amount);
        return redeemInternal(_amount);
    }

    function redeemInternal(uint256 redeemAmount) internal returns (uint256){
        uint256 redeemTotal = redeemAmount.add(redeemAmount.mul(ratio).div(10));
        IERC20 underlying = IERC20(erc20Address);

        if (underlying.balanceOf(address(this)) < redeemTotal) {
            redeemTotal = redeemAmount;
        }
        underlying.transfer(msg.sender, redeemTotal);
        balanceOf[msg.sender] -= redeemAmount;
        return uint256(0);
    }

    function redeemUnderlying(uint256 amount) external pure returns (uint256){
        require(amount > 0, "MockCErc20 : AMOUNT_IS_ZERO");
        return uint256(0);
    }
}
