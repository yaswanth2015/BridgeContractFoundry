// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;
import "forge-std/Test.sol";
import "../../src/DestinationChainContracts/DestinationChainToken.sol";


contract TestDestinationChainTokenTest is Test {
    DestinationChainToken token;
    address user = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    event ConvertToNativeToken(address indexed _to, uint256 value, uint256 timestamp);

    function setUp() public {
        token = new DestinationChainToken("Yash", "YT");
    }

    function testFailMint() public {
        //Only Owner can mint the tokens
        vm.startPrank(user);
        token.mint(user, 100);
    }

    function testMint() public {
        //Only Owner can mint the tokens
        token.mint(user, 100);
        assertEq(token.balanceOf(user), 100, "Balances are not equal");
    }

    function testBurn() public {
        token.mint(user, 100);

        //Burning coins for the user
        vm.startPrank(user);
        token.burn(100);
        vm.stopPrank();


        assertEq(token.balanceOf(user), 0, "Balance are not matched");
    }

    function testBurnEvent() public {
        token.mint(user,100);

        //Testing the event after burning coins
        vm.startPrank(user);
        vm.expectEmit(true, false, false, true);
        emit ConvertToNativeToken(user, 50, block.timestamp);

        token.burn(50);

        assertEq(token.balanceOf(user), 50, "Balances are not equal");
    }


}