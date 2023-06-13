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
        
    }
}