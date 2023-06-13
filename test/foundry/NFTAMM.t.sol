// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./utils/NFT-AMMTestBase.sol";

contract NFTAMMTest is NFTAMMTestBase {

    function setUp() public {
        _setUp();
    }

    function test_NA_Deployment() public {
        assertEq(nftAMM.ONE_ETH(), 10 ** 18);
        assertEq(address(nftAMM.WETH()), address(weth));
        assertEq(address(nftAMM.fragmentation()), address(fragmentation));
        assertEq(address(nftAMM.calculate()), address(calculate));
        assertEq(address(nftAMM.WETHAddr()), address(weth));
        assertEq(address(nftAMM.fundContract()), address(fund));
        
    }

    function test_NA_receive_Success() public {
        deal(alice, 1000 ether);
    }

    function test_NA_addLiquidityWithETH_Success() public {
        myNFT.safeMint(alice);
        vm.startPrank(alice);
        myNFT.approve(address(fragmentation), myNFT.getTokenId());
        fragmentation.tearApartNFT(address(myNFT), myNFT.getTokenId());
        address FT = fragmentation.getFTAddr(address(myNFT));
        uint256 ftBalanceAlice = IERC20(FT).balanceOf(alice);
        assertEq(ftBalanceAlice, fragmentation.ONE_ETH() * 1000);
        deal(alice, 1000 ether);
        IERC20(nftAMM.WETHAddr()).approve(address(nftAMM), 1 ether);
        IERC20(FT).approve(address(nftAMM), ftBalanceAlice);
        nftAMM.addLiquidityWithETH{value: 1 ether}(FT, ftBalanceAlice);
        
    }

    function test_NA_addLiquidityWithFT_Success() public {
        myNFT.safeMint(alice);
        vm.startPrank(alice);
        myNFT.approve(address(fragmentation), myNFT.getTokenId());
        fragmentation.tearApartNFT(address(myNFT), myNFT.getTokenId());
        address FT = fragmentation.getFTAddr(address(myNFT));
        uint256 ftBalanceAlice = IERC20(FT).balanceOf(alice);
        assertEq(ftBalanceAlice, fragmentation.ONE_ETH() * 1000);
        deal(DAI, alice, 100000);
        IERC20(DAI).approve(address(nftAMM), 100000);
        IERC20(FT).approve(address(nftAMM), ftBalanceAlice);
        nftAMM.addLiquidityWithFT(FT, DAI, ftBalanceAlice, 100);
    }

    function test_NA_addLiquidity_Success() public {

    }

    function test_NA_removeLiquidity_Success() public {

    }

}