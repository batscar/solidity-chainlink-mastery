
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "projects/01.advanced-simple-Storage/contracts/ADSS.sol";

contract AdvancedSimpleStorageTest is Test {
    AdvancedSimpleStorage public adss;

    function setUp() public {
        adss = new AdvancedSimpleStorage();
    }

    function test_InitialFavoriteNumber() public {
        assertEq(adss.getFavoriteNumber(), 0);
    }

    function test_SetFavoriteNumber() public {
        adss.setFavoriteNumber(42);
        assertEq(adss.getFavoriteNumber(), 42);
    }

    function test_OwnerIsSetCorrectly() public {
        assertEq(adss.owner(), address(this));
    }

    function test_SetName() public {
        adss.setName("sunny");
        assertEq(adss.name(), "sunny");
    }

    function test_RevertWhenNonOwnerSetsName() public {
        vm.prank(address(0x123));
        vm.expectRevert(AdvancedSimpleStorage.OnlyOwnerCanCall.selector);
        adss.setName("hacker");
    }

    function test_ToggleActive() public {
        bool initial = adss.isActive();
        adss.toggleActive();
        assertEq(adss.isActive(), !initial);
    }

    function test_ResetAll() public {
        adss.setFavoriteNumber(99);
        adss.resetAll();
        assertEq(adss.getFavoriteNumber(), 0);
    }
}

