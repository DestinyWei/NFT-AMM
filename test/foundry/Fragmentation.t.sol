// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./utils/NFT-AMMTestBase.sol";

contract FragmentationTest is NFTAMMTestBase {
    function setUp() public {
        _setUp();
    }

    function test_FG_Deployment() public {
        assertEq(fragmentation.ONE_ETH(), 10 ** 18);
    }

    function test_FG_TearApartNFT_Success() public {
        mintNFT();

        vm.prank(alice);
        fragmentation.tearApartNFT(address(myNFT), 0);
        address FTaddr = fragmentation.FTAddressList(0);
        uint256 balance = FT(FTaddr).balanceOf(alice);
        assertEq(balance, 1000e18);
        assertTrue(fragmentation.nft_StakeIndex(alice, address(myNFT), 0));
        assertTrue(fragmentation.isFTCreated(address(myNFT)));
        assertTrue(fragmentation.isFTToken(address(FTaddr)));
    }

    function test_FG_RecoverNFT_Success() public {
        mintNFT();

        vm.prank(alice);
        fragmentation.tearApartNFT(address(myNFT), 0);
        address FTaddr = fragmentation.FTAddressList(0);

        vm.prank(alice);
        fragmentation.recoverNFT(address(myNFT), 0);
        uint256 balance = FT(FTaddr).balanceOf(alice);
        assertEq(balance, 0);
        assertFalse(fragmentation.nft_StakeIndex(alice, address(myNFT), 0));
    }

    function test_FG_GetFTAddr_Success() public {
        mintNFT();

        vm.prank(alice);
        fragmentation.tearApartNFT(address(myNFT), 0);
        vm.prank(alice);
        fragmentation.recoverNFT(address(myNFT), 0);
        address FTaddr = fragmentation.FTAddressList(0);
        uint256 balance = FT(FTaddr).balanceOf(alice);
        assertEq(balance, 0);
    }

    function test_FG_GetFTLength_Success() public {
        mintNFT();

        uint256 length = fragmentation.getFTLength();
        assertEq(length, 0);

        vm.prank(alice);
        fragmentation.tearApartNFT(address(myNFT), 0);
        length = fragmentation.getFTLength();
        assertEq(length, 1);
    }

    function mintNFT() private {
        myNFT.safeMint(alice);
        uint256 latestTokenID = myNFT.getTokenId();
        vm.prank(alice);
        myNFT.approve(address(fragmentation), latestTokenID);
    }
}
