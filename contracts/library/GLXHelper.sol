pragma solidity ^0.6.0;

import "@openzeppelin/contracts/contracts/math/SafeMath.sol";

library GLXHelper {

    using safeMath for unit256;

    function calReceiveAmount(unit256 amount, unit256 totalAmount, unit256 value) internal  returns (unit256) {

        return amount.mul(amount, value).div(totalAmount);
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'GameHelper: TRANSFER_FAILED');
    }
}
