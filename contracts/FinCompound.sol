pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./IFin.sol";
import "./IErc20.sol";
import "./ICErc20.sol";

contract FinCompound is Ownable {

    event MyLog(string, uint256);

    address public erc20Address;
    address public cerc20Address;

    function setTokenAddress(address _erc20Address, address _cerc20Address) external onlyOwner {
        require(address(_erc20Address) != address(0));
        require(address(_cerc20Address) != address(0));
        erc20Address = _erc20Address;
        cerc20Address = _cerc20Address;
    }

    // ropsten USDT 0x516de3a7a567d81737e3a46ec4ff9cfd1fcb0136
    // ropsten cUSDT 0x135669c2dcbd63f639582b313883f101a4497f76
    function supplyErc20(uint256 _numTokensToSupply) public returns (uint) {
        require(_numTokensToSupply > 0);
        // Create a reference to the underlying asset contract, like DAI.

        IErc20 underlying = IErc20(erc20Address);

        // Create a reference to the corresponding cToken contract, like cDAI
        ICErc20 cToken = ICErc20(cerc20Address);

        // Amount of current exchange rate from cToken to underlying
        uint256 exchangeRateMantissa = cToken.exchangeRateCurrent();
        emit MyLog("Exchange Rate (scaled up by 1e18): ", exchangeRateMantissa);

        // Amount added to you supply balance this block
        uint256 supplyRateMantissa = cToken.supplyRatePerBlock();
        emit MyLog("Supply Rate: (scaled up by 1e18)", supplyRateMantissa);

        // Approve transfer on the ERC20 contract
        underlying.approve(cerc20Address, _numTokensToSupply);

        // Mint cTokens
        uint mintResult = cToken.mint(_numTokensToSupply);
        return mintResult;
    }

    function redeemErc20(uint256 amount) public returns (bool) {
        require(amount > 0);
        // Create a reference to the corresponding cToken contract, like cDAI

        ICErc20 cToken = ICErc20(cerc20Address);

        // `amount` is scaled up by 1e18 to avoid decimals

        uint256 redeemResult = cToken.redeemUnderlying(amount);

        // Error codes are listed here:
        // https://compound.finance/developers/ctokens#ctoken-error-codes
        emit MyLog("If this is not 0, there was an error", redeemResult);

        return true;
    }
}
