// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./utils/NFT-AMMTestBase.sol";

contract NFTAMMTest is NFTAMMTestBase {

    function _setUp() public {
        setUp();
    }

    function test_NA_Deployment() public {
        assertEq(nftAMM.ONE_ETH(), 10 ** 18);
        assertEq(address(nftAMM.WETH()), address(weth));
        assertEq(address(nftAMM.fragmentation()), address(fragmentation));
        assertEq(address(nftAMM.calculate()), address(calculate));
        assertEq(address(nftAMM.WETHAddr()), address(weth));
        assertEq(address(nftAMM.fundContract()), address(fund));
        
    }

    function test_NA_addLiquidityWithETH_Success() public {
        myNFT.safeMint(alice);
        vm.prank(alice);
        fragmentation.tearApartNFT(address(myNFT), myNFT.getTokenId());
    }

    function test_NA_addLiquidityWithFT_Success() public {

    }

}