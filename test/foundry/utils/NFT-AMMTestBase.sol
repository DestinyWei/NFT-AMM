// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./import.sol";

contract NFTAMMTestBase is Test {
    WETH public weth;
    Fragmentation public fragmentation;
    FTCalculate public calculate;
    FundContract public fund;
    NFTAMM public nftAMM;
    Router public router;
    DexToken public dexToken;
    FT public ft;
    LPToken public lpToken;
    MyNFT public myNFT;
    //StakingRewards public stakingRewards;

    address public constant USDT = 0xA1d7f71cbBb361A77820279958BAC38fC3667c1a;

    Utils utils;
    address payable[] internal users;
    address internal alice;
    address internal bob;
    address internal charlie;
    address internal dennis;

    uint256 public sepoliaFork;
    string public SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");
    uint256 public constant BLOCK_NUM = 3648420;

    function _setUp() internal {
        sepoliaFork = vm.createSelectFork(SEPOLIA_RPC_URL, BLOCK_NUM);

        utils = new Utils();
        users = utils.createUsers(4);
        alice = users[0];
        bob = users[1];
        charlie = users[2];
        dennis = users[3];

        weth = new WETH();
        fragmentation = new Fragmentation();
        calculate = new FTCalculate();
        fund = new FundContract();
        nftAMM = new NFTAMM(address(weth), address(fragmentation), address(calculate), address(fund));
        router = new Router(address(nftAMM));
        dexToken = new DexToken();
        ft = new FT();
        lpToken = new LPToken();
        myNFT = new MyNFT();
        //stakingRewards = new StakingRewards(lpToken, DexToken);   
    }
}