pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockCErc20 is Ownable {

    mapping (address => uint256) public balanceOf;

    address public erc20Address;

    function setTokenAddress(address _erc20Address) external onlyOwner {
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

    function exchangeRateCurrent() external pure returns (uint256){
        return uint256(0);
    }

    function supplyRatePerBlock() external pure returns (uint256){
        return uint256(0);
    }

    function redeem(uint _amount) external returns (uint){
        require(_amount > 0);
        require(balanceOf[msg.sender] >= _amount);
        return redeemInternal(_amount);
    }

    function redeemInternal(uint redeemAmount) internal returns (uint){
        IERC20 underlying = IERC20(erc20Address);
        underlying.transfer(msg.sender, redeemAmount);
        balanceOf[msg.sender] -= redeemAmount;
        return uint(0);
    }

    function redeemUnderlying(uint _amount) external returns (uint){
        return uint(0);
    }
}
