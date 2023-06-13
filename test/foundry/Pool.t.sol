// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Utils} from "./utils/Utils.sol";
import "../../contracts/FT.sol";
import "../../contracts/LPToken.sol";
import "../../contracts/Pool.sol";

contract PoolTest is Test {
    StakingRewards public pool;
    FT public stakingToken;
    LPToken public rewardsToken;

    Utils utils;
    address payable[] internal users;
    address internal alice;
    address internal bob;
    address internal charlie;
    address internal dennis;

    uint256 public sepoliaFork;
    string public SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");
    uint256 public constant BLOCK_NUM = 3648420;

    function setUp() public {
        sepoliaFork = vm.createSelectFork(SEPOLIA_RPC_URL, BLOCK_NUM);

        utils = new Utils();
        users = utils.createUsers(4);
        alice = users[0];
        bob = users[1];
        charlie = users[2];
        dennis = users[3];

        stakingToken = new FT();
        rewardsToken = new LPToken();
        pool = new StakingRewards(address(stakingToken), address(rewardsToken));
    }

    function test_P_Deployment() public {
        assertEq(address(pool.stakingToken()), address(stakingToken));
        assertEq(address(pool.rewardsToken()), address(rewardsToken));
    }

    function test_P_stake() public {
        stakingToken.mint(alice, 100);
        vm.prank(alice);
        stakingToken.approve(address(pool), 10);
        vm.prank(alice);
        pool.stake(10);
        assertEq(pool.totalSupply(), 10);
    }
}
