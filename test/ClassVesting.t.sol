// SPDX-License-Identifier: MIT
pragma solidity 0.8.36;

import {Test} from "forge-std/Test.sol";
import {ClassToken} from "../src/ClassToken.sol";
import {ClassVesting} from "../src/ClassVesting.sol";

contract ClassVestingTest is Test {
    uint256 internal constant CLIFF = 1_790_186_400;
    uint256 internal constant END = 1_790_272_800;
    ClassToken internal token;
    ClassVesting internal vesting;
    address internal alice = address(0xA11CE);
    address internal bob = address(0xB0B);
    address internal carol = address(0xCA);
    address internal dave = address(0xDA);
    address internal eve = address(0xE);
    address internal frank = address(0xF);
    address internal grace = address(0x99);
    address[] internal beneficiaries;

    function setUp() public {
        beneficiaries = _beneficiaries();
        token = new ClassToken();
        vesting = new ClassVesting(address(token), beneficiaries, CLIFF, END);
        token.transfer(address(vesting), 7_000);
    }

    function _beneficiaries() internal view returns (address[] memory list) {
        list = new address[](7);
        list[0] = alice; list[1] = bob; list[2] = carol; list[3] = dave;
        list[4] = eve; list[5] = frank; list[6] = grace;
    }

    function test_TotalSupplyIs7000() public view { assertEq(token.totalSupply(), 7_000); }
    function test_VestingContractFundedWith7000() public view { assertEq(token.balanceOf(address(vesting)), 7_000); }

    function test_EachBeneficiaryHas1000Allocation() public view {
        for (uint256 i = 0; i < beneficiaries.length; i++) assertEq(vesting.allocationOf(beneficiaries[i]), 1_000);
    }

    function test_NothingBeforeCliff() public {
        vm.warp(CLIFF - 1); assertEq(vesting.releasable(alice), 0);
        vm.prank(alice); vm.expectRevert(ClassVesting.NothingToClaim.selector); vesting.claim();
    }

    function test_CliffUnlocks100() public {
        vm.warp(CLIFF); assertEq(vesting.releasable(alice), 100);
        vm.prank(alice); vesting.claim();
        assertEq(token.balanceOf(alice), 100); assertEq(vesting.claimedOf(alice), 100);
    }

    function test_LinearDuringDay() public { vm.warp(CLIFF + 43_200); assertEq(vesting.releasable(alice), 550); }

    function test_FullAtEnd() public {
        vm.warp(END); assertEq(vesting.releasable(alice), 1_000);
        vm.prank(alice); vesting.claim();
        assertEq(token.balanceOf(alice), 1_000); assertEq(vesting.claimedOf(alice), 1_000);
    }

    function test_ClaimPartialThenClaimRemainder() public {
        vm.warp(CLIFF + 43_200); vm.prank(alice); vesting.claim();
        assertEq(token.balanceOf(alice), 550); assertEq(vesting.claimedOf(alice), 550);
        vm.warp(END); vm.prank(alice); vesting.claim();
        assertEq(token.balanceOf(alice), 1_000); assertEq(vesting.claimedOf(alice), 1_000);
        vm.prank(alice); vm.expectRevert(ClassVesting.NothingToClaim.selector); vesting.claim();
    }

    function test_CannotClaimOthers() public {
        vm.warp(END); vm.prank(bob); vesting.claim();
        assertEq(token.balanceOf(bob), 1_000); assertEq(token.balanceOf(alice), 0);
        assertEq(vesting.claimedOf(bob), 1_000); assertEq(vesting.claimedOf(alice), 0);
    }

    function test_NonBeneficiaryCannotClaim() public {
        address stranger = address(0x1234); vm.warp(END);
        assertEq(vesting.releasable(stranger), 0);
        vm.prank(stranger); vm.expectRevert(ClassVesting.NothingToClaim.selector); vesting.claim();
    }

    function test_ClaimAfterEndRemainsCappedAt1000() public {
        vm.warp(END + 30 days); vm.prank(alice); vesting.claim();
        assertEq(token.balanceOf(alice), 1_000); assertEq(vesting.releasable(alice), 0);
    }

    function test_DuplicateBeneficiariesRejected() public {
        address[] memory duplicateList = _beneficiaries(); duplicateList[1] = duplicateList[0];
        vm.expectRevert(ClassVesting.DuplicateBeneficiary.selector);
        new ClassVesting(address(token), duplicateList, CLIFF, END);
    }

    function test_AllAllocationsEqualTotalSupply() public view {
        uint256 total;
        for (uint256 i = 0; i < beneficiaries.length; i++) total += vesting.allocationOf(beneficiaries[i]);
        assertEq(total, token.totalSupply());
    }
}
