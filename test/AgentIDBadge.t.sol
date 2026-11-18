// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/AgentIDBadge.sol";
import "../src/MockAgentID.sol";

contract AgentIDBadgeTest is Test {
    MockAgentID mock;
    AgentIDBadge badge;
    address holder = address(0x1234);
    address stranger = address(0x5678);

    function setUp() public {
        mock = new MockAgentID();
        badge = new AgentIDBadge(address(mock));
        mock.setBalance(holder, 1);
    }

    function testMintByHolderOK() public {
        vm.prank(holder);
        badge.mint();
        assertEq(badge.ownerOf(1), holder);
        assertTrue(badge.hasMinted(holder));
        assertEq(badge.nextTokenId(), 2);
    }

    function testMintByNonHolderReverts() public {
        vm.prank(stranger);
        vm.expectRevert(AgentIDBadge.NotAgentIDHolder.selector);
        badge.mint();
    }

    function testDoubleMintReverts() public {
        vm.prank(holder);
        badge.mint();
        vm.prank(holder);
        vm.expectRevert(AgentIDBadge.AlreadyMinted.selector);
        badge.mint();
    }

    function testPauseMintReverts() public {
        vm.prank(address(this));
        badge.pause();
        vm.prank(holder);
        vm.expectRevert(AgentIDBadge.MintPaused.selector);
        badge.mint();
    }

    function testUnpauseMintWorks() public {
        vm.prank(address(this));
        badge.pause();
        vm.prank(address(this));
        badge.unpause();
        vm.prank(holder);
        badge.mint();
        assertEq(badge.ownerOf(1), holder);
    }

    function testNonOwnerCannotPause() public {
        vm.prank(stranger);
        vm.expectRevert();
        badge.pause();
    }

function testZeroAddressConstructorReverts() public {
    vm.expectRevert(AgentIDBadge.ZeroAddress.selector);
    new AgentIDBadge(address(0));
}

function testSupplyCapViaStorage() public {
    vm.store(address(badge), bytes32(uint256(7)), bytes32(uint256(1000)));
    vm.prank(holder);
    badge.mint();
    assertEq(badge.ownerOf(1000), holder);

    mock.setBalance(stranger, 1);
    vm.prank(stranger);
    vm.expectRevert(AgentIDBadge.MaxSupplyReached.selector);
    badge.mint();
}

function testTokenURIHasDataPrefix() public {
    vm.prank(holder);
    badge.mint();
    string memory uri = badge.tokenURI(1);
    assertTrue(bytes(uri).length > 100);

    bytes memory uriBytes = bytes(uri);
    bytes memory prefix = bytes("data:application/json;base64,");
    bytes memory slice = new bytes(prefix.length);
    for (uint256 i = 0; i < prefix.length; i++) {
        slice[i] = uriBytes[i];
    }
    assertEq(keccak256(slice), keccak256(prefix));
}

function testTokenURIDiffersPerToken() public {
    mock.setBalance(stranger, 1);
    vm.prank(holder);
    badge.mint();
    vm.prank(stranger);
    badge.mint();
    assertTrue(keccak256(bytes(badge.tokenURI(1))) != keccak256(bytes(badge.tokenURI(2))));
}

function testTokenURINonexistentReverts() public {
    vm.expectRevert(abi.encodeWithSelector(AgentIDBadge.NonexistentToken.selector, 999));
    badge.tokenURI(999);
}

function testTransferWorks() public {
    vm.prank(holder);
    badge.mint();
    vm.prank(holder);
    badge.transferFrom(holder, stranger, 1);
    assertEq(badge.ownerOf(1), stranger);
}

function testBadgeMintedEvent() public {
    vm.expectEmit(true, true, false, true, address(badge));
    emit AgentIDBadge.BadgeMinted(holder, 1);
    vm.prank(holder);
    badge.mint();
}
}
