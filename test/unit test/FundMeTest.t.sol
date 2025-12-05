// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;

    address EXECUTOR = makeAddr("executor");
    uint256 constant STARTING_VALUE = 10 ether;
    uint256 constant SEND_VALUE = 0.1 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(EXECUTOR, STARTING_VALUE);
    }

    function testMinimumUSD() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testSenderIsOwner() public view {
        console.log(msg.sender);
        console.log(address(this));
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testGetVersion() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailValueInsuffi() public {
        vm.expectRevert();
        fundMe.fund();
    }

    //function testFundSuccessStateUpdated() public {
    //   fundMe.fund{value: 10e18}();
    //   assertEq(fundMe.s_addressToAmountFunded(address(this)), 10e18);
    //  assertEq(fundMe.s_funders(0), address(this));
    //}

    function testFundSuccessStateUpdated2() public funded {
        assertEq(fundMe.getAdressToAmountFunded(EXECUTOR), 10e18);
        assertEq(fundMe.getFunders(0), EXECUTOR);
    }

    modifier funded() {
        vm.prank(EXECUTOR);
        fundMe.fund{value: 10e18}();
        _;
    }

    function testWithdrawable() public funded {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawSuccess() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 fundMeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.i_owner());
        fundMe.withdraw();
        //Assert
        uint256 endOwnerBalance = fundMe.i_owner().balance;
        assertEq(startingOwnerBalance + fundMeBalance, endOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 startingFunder = 1;
        uint160 numberOfFunder = 10;
        for (uint160 i = startingFunder; i < numberOfFunder; i++) {
            hoax(address(i), STARTING_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        //Arrange
        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 fundMeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.i_owner());
        fundMe.withdraw();
        //Assert
        uint256 endOwnerBalance = fundMe.i_owner().balance;
        assertEq(startingOwnerBalance + fundMeBalance, endOwnerBalance);
    }
}
