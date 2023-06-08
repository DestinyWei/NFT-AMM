// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../contracts/NFTAMM.sol";
import "../../contracts/WETH.sol";
import "../../contracts/fundContract.sol";
import "../../contracts/Calculate.sol";
import "../../contracts/Fragmentation.sol";

contract NFTAMMTest is Test {
    WETH weth;
    Fragmentation fragmentation;
    FTCalculate calculate;
    FundContract fund;
    NFTAMM nftAMM;

    function _setUp() public {
        weth = new WETH();
        fragmentation = new Fragmentation();
        calculate = new FTCalculate();
        fund = new FundContract();
        nftAMM = new NFTAMM(address(weth), address(fragmentation), address(calculate), address(fund));

    }

    function test_NA_Deployment() public {
        assertEq(nftAMM.ONE_ETH(), 10 ** 18);
    }

    function test_NA_addLiquidityWithETH_Success() public {

    }

    function test_NA_addLiquidityWithFT_Success() public {

    }

}