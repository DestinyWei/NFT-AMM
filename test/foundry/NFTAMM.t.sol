// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./utils/NFT-AMMTestBase.sol";

contract NFTAMMTest is NFTAMMTestBase {

    function _setUp() public {
        setUp();
    }

    function test_NA_Deployment() public {
        assertEq(nftAMM.ONE_ETH(), 10 ** 18);

    }

    function test_NA_addLiquidityWithETH_Success() public {

    }

    function test_NA_addLiquidityWithFT_Success() public {

    }

}