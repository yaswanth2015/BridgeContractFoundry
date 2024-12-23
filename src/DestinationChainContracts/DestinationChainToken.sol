// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract DestinationChainToken is ERC20, Ownable {
    event ConvertToNativeToken(address indexed _to, uint256 value, uint256 timestamp);

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) Ownable(msg.sender) {

    }

    function mint(address _to, uint256 value) onlyOwner public {
        _mint(_to, value);
    }

    function burn(uint256 value) public {
        _burn(_msgSender(), value);
        emit ConvertToNativeToken(_msgSender(), value, block.timestamp);
    }
}