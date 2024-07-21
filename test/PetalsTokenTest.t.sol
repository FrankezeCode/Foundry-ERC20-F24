// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployPetalsToken} from "script/DeployPetalsToken.s.sol";
import {PetalsToken} from "src/PetalsToken.sol";

contract PetalsTokenTest is Test {
    PetalsToken public petalsToken ;
    DeployPetalsToken public deployer;

    address bob = makeAddr("bob");
    address joy = makeAddr("joy");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployPetalsToken();
        petalsToken = deployer.run();

        vm.prank(msg.sender);
        petalsToken.transfer(bob,STARTING_BALANCE );
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, petalsToken.balanceOf(bob));
    }

    function testAllowances() public  {
        uint256 initialAllowance = 1000;
        vm.prank(bob);
        petalsToken.approve(joy, initialAllowance);
        
        uint256 transferAmount = 500;

        vm.prank(joy);
        petalsToken.transferFrom(bob, joy, transferAmount);

        assertEq(petalsToken.balanceOf(joy), transferAmount);
        assertEq(petalsToken.balanceOf(bob), STARTING_BALANCE - transferAmount);

    }

     function testInitialSupply() public view {
        assertEq(petalsToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testTransferFrom() public {
        uint256 approveAmount = 100 ether;
        uint256 transferAmount = 50 ether;

        // User1 approves user2 to spend tokens on their behalf
        vm.prank(bob);
        petalsToken.approve(joy, approveAmount);

        // User2 transfers tokens from user1 to themselves
        vm.prank(joy);
        petalsToken.transferFrom(bob, joy, transferAmount);

        assertEq(petalsToken.balanceOf(bob), 50 ether);
        assertEq(petalsToken.balanceOf(joy), transferAmount);
        assertEq(petalsToken.allowance(bob, joy), approveAmount - transferAmount);
    }

    function testInsufficientBalanceTransfer() public {
        uint256 transferAmount = 2000 ether;

        // User1 tries to transfer more tokens than they have
        vm.prank(bob);
        vm.expectRevert();
        petalsToken.transfer(joy, transferAmount);
    }

    function testInsufficientAllowanceTransferFrom() public {
        uint256 approveAmount = 50 ether;
        uint256 transferAmount = 100 ether;

        // User1 approves user2 to spend some tokens on their behalf
        vm.prank(bob);
        petalsToken.approve(joy, approveAmount);

        // User2 tries to transfer more tokens than allowed
        vm.prank(joy);
        vm.expectRevert();
        petalsToken.transferFrom(bob, joy, transferAmount);
    }

    
}