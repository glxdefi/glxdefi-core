pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./ICErc20.sol";

contract FinCompound is Ownable {

    address public cerc20Address;

    function setTokenAddress(address _erc20Address, address _cerc20Address) external onlyOwner {
        require(address(_erc20Address) != address(0));
        require(address(_cerc20Address) != address(0));
        erc20Address = _erc20Address;
        cerc20Address = _cerc20Address;
    }

    function supply(address token, uint256 _numTokensToSupply) public returns (uint) {
        require(_numTokensToSupply > 0);

        IERC20 underlying = IERC20(token);
        ICErc20 cToken = ICErc20(cerc20Address);

        underlying.approve(cerc20Address, _numTokensToSupply);

        uint mintResult = cToken.mint(_numTokensToSupply);
        return mintResult;
    }

    function redeem(address token, uint256 amount) public returns (bool) {
        require(amount > 0);

        ICErc20 cToken = ICErc20(cerc20Address);
        uint256 redeemResult = cToken.redeem(amount);
        return true;
    }
}
