// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import "../../src/EthChainContracts/NativeEthToken.sol";
import "../../src/EthChainContracts/NativeEthTokenBridge.sol";


contract TestNativeEthTokenBridge is Test {
    NativeEthToken token;
    NativeEthTokenBridge bridge;
    address user = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    event MoneyReceivedFrom(address indexed depositer, uint256 amount, uint256 timestamp);
    event ConvertedToNativeToken(address indexed receiver, uint256 amount, uint256 timestamp);

    function setUp() public {
        token = new NativeEthToken(address(this), "Yash", "YT");
        bridge = new NativeEthTokenBridge(address(this), address(token));
        token.mint(user, 100);
    }

    function testdepositfailCondition() public {
        token.mint(user, 100);


        vm.startPrank(user);
        vm.expectRevert();


        bridge.deposit(100);
        vm.stopPrank();
    }

    function testdeposit() public {
        vm.startPrank(user);
        token.approve(address(bridge), 50);
        bridge.deposit(50);
        vm.stopPrank();
    }

    function testDepoiteEvent() public {
        vm.startPrank(user);

        //User approves the allowance
        token.approve(address(bridge), 50);

        vm.expectEmit(true, false, false, true);
        emit MoneyReceivedFrom(user, 50, block.timestamp);

        //user calls deposit function which will emit MoneyReceivedFrom
        bridge.deposit(50);
        vm.stopPrank();
    }

    function testSendToUser() public {
        //having initial balance of 100 in bridge acoount
        token.mint(address(bridge) , 100);
        uint256 initialbalanceofuser = token.balanceOf(user);

        bridge.sendToUser(user, 50);

        assertEq(token.balanceOf(user), initialbalanceofuser + token.balanceOf(address(bridge)), "Both Balances are not equal");
        

    }

    function testSendToUserEvent() public {
        //having initial balance of 100 in bridge acoount
        token.mint(address(bridge) , 100);

        //ExpectEvent after sending the amount to user
        vm.expectEmit(true, false, false, true);
        emit ConvertedToNativeToken(user, 50, block.timestamp);


        bridge.sendToUser(user, 50);
    }

}