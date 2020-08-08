pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

library GLXHelper {

    using SafeMath for uint256;

    function calReceiveAmount(uint256 amount, uint256 totalAmount, uint256 value) internal pure returns (uint256) {
        uint256 winAmount = amount.mul(value).div(totalAmount);
        //除了赢的钱，还需要归还本金
        return winAmount.add(amount);
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'GameHelper: TRANSFER_FAILED');
    }


    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'GameHelper: TRANSFER_FROM_FAILED');
    }

    function safeMint(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('mint(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x40c10f19, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'GameHelper: MINT_FAILED');
    }


}
