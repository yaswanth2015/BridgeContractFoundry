// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract NativeEthTokenBridge is Ownable {
    address tokenAddress;
    mapping (address => uint256) balances;
    event MoneyReceivedFrom(address indexed depositer, uint256 amount, uint256 timestamp);
    event ConvertedToNativeToken(address indexed receiver, uint256 amount, uint256 timestamp);

    constructor(address _owner, address _tokenaddress) Ownable(_owner) {
        tokenAddress = _tokenaddress;
    }

    /** 
    * @param value amount deposited by the user
    * @dev used by the user to deposit amount into bridge account address
    */
    function deposit(uint256 value) public {
        IERC20(tokenAddress).transferFrom(_msgSender(), address(this), value);
        emit MoneyReceivedFrom(_msgSender(), value, block.timestamp);
    }
    /**
     * 
     * @param receiver reciver address
     * @param amount ammount to be received by the user
     * @dev only owner will trigger the contract to witdraw amount from bridge account address and send it to the receiver account
     */

    function withDraw(address receiver, uint256 amount) public onlyOwner() {
        IERC20(tokenAddress).transfer(receiver, amount);
        emit ConvertedToNativeToken(receiver, amount, block.timestamp);
    }
}