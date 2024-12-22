// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NativeEthToken is ERC20, Ownable {

    constructor(address owner, string memory name, string memory symbol) ERC20(name, symbol) Ownable(owner) {

    }

    function mint(address _to, uint256 value) public {
        _mint(_to, value);
    }
}
