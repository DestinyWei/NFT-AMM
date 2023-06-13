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
        vm.prank(alice);
        address(nftAMM).call{value: 10 ether}()
        assertEq(alice.balance, 990);
        assertEq(address(nftAMM).balance, 10);
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
        deal(DAI, alice, 100000);
        deal(USDC, alice, 100000);
        vm.startPrank(alice);
        IERC20(DAI).approve(address(nftAMM), 100000);
        IERC20(USDC).approve(address(nftAMM), 100000);
        nftAMM.addLiquidity(USDC, DAI, 1000, 1000);
    }

    function test_NA_removeLiquidity_Success() public {
        deal(DAI, alice, 100000);
        deal(USDC, alice, 100000);
        vm.startPrank(alice);
        IERC20(DAI).approve(address(nftAMM), 100000);
        IERC20(USDC).approve(address(nftAMM), 100000);
        nftAMM.addLiquidity(USDC, DAI, 1000, 1000);
        nftAMM.removeLiquidity(USDC, DAI, 899);
    }

    function test_NA_removeLiquidity_NotAddLiquidity_Fail() public {
        vm.expectRevert();
        nftAMM.removeLiquidity(USDC, DAI, 1000);
    }

    function test_NA_removeLiquidity_ShouldLeft100WeiInPool_Fail() public {
        deal(DAI, alice, 100000);
        deal(USDC, alice, 100000);
        vm.startPrank(alice);
        IERC20(DAI).approve(address(nftAMM), 100000);
        IERC20(USDC).approve(address(nftAMM), 100000);
        nftAMM.addLiquidity(USDC, DAI, 1000, 1000);
        vm.expectRevert("paieCreator should left 100 wei lptoken in pool");
        nftAMM.removeLiquidity(USDC, DAI, 1000);
    }

    function test_NA_swapWithETH_Success() public {
        _addLiquidityWithETH();
        IERC20(nftAMM.WETHAddr()).approve(address(nftAMM), 1 ether);
        nftAMM.swapWithETH{value: 1 ether}(FT, 10000);
    }

    function test_NA_swapToETH_Success() public {
        _addLiquidityWithETH();
        deal(FT, alice, 1000000);
        IERC20(FT).approve(address(nftAMM), 100000);
        nftAMM.swapToETH(FT, 100000, 1000);
    }

    function test_NA_swapToETH_SliTooLarge_Fail()  returns () {
        _addLiquidityWithETH();
        deal(FT, alice, 1000000);
        IERC20(FT).approve(address(nftAMM), 100000);
        nftAMM.swapToETH(FT, 100000, 1);
    }

    function test_NA_swap_Success() public {
        _addLiquidity();
        IERC20(DAI).approve(address(nftAMM), 1 ether);
        IERC20(USDC).approve(address(nftAMM), 1 ether);
        nftAMM.swap(DAI, USDC, 0.0005 ether);
    }

    function test_NA_swapByLimitSli_Success() public {
        _addLiquidity();
        IERC20(DAI).approve(address(nftAMM), 1 ether);
        IERC20(USDC).approve(address(nftAMM), 1 ether);
        nftAMM.swapByLimitSli(DAI, USDC, 0.0005 ether, 10000);
    }

    function test_NA_swapByLimitSli_SliTooLarge_Fail() public {
        _addLiquidity();
        IERC20(DAI).approve(address(nftAMM), 1 ether);
        IERC20(USDC).approve(address(nftAMM), 1 ether);
        nftAMM.swapByLimitSli(DAI, USDC, 0.0005 ether, 10);
    }

    function _addLiquidityWithETH() private {
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

    function _addLiquidity() private {
        deal(DAI, alice, 1 ether);
        deal(USDC, alice, 1 ether);
        vm.startPrank(alice);
        IERC20(DAI).approve(address(nftAMM), 1 ether);
        IERC20(USDC).approve(address(nftAMM), 1 ether);
        nftAMM.addLiquidity(USDC, DAI, 0.5 ether, 0.5 ether);
    }
}