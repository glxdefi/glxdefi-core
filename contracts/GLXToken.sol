pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GLXToken is Ownable, ERC20 {

    address public maker;

    modifier onlyMaker() {
        require(maker == _msgSender(), "Maker: caller is not the maker");
        _;
    }

    constructor() public ERC20("GLXToken", "GLX") {
    }

    function setMaker(address _maker) public onlyOwner {
        maker = _maker;
    }

    function mint(address receiver, uint amount) public onlyMaker {
        _mint(receiver, amount);
    }

    function burn(address account, uint amount) public onlyMaker {
        _burn(account, amount);
    }
}
