<<<<<<< HEAD


=======
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

    function test_P_lastTimeRewardApplicable() public {
        // set the variable value
        updateVariable();

        uint256 time = pool.lastTimeRewardApplicable();
        assertEq(time, block.timestamp);

        vm.warp(block.timestamp + 100);
        time = pool.lastTimeRewardApplicable();
        assertEq(time, pool.finishAt());
    }

    function test_P_rewardPerToken() public {
        uint256 perToken = pool.rewardPerToken();
        assertEq(perToken, 0);

        // set the variable value
        updateVariable();

        perToken = pool.rewardPerToken();
        assertEq(perToken, 4e17);
    }

    function test_P_resetToken() public {
        FT newStakingToken = new FT();
        LPToken newRewardsToken = new LPToken();
        pool.resetToken(address(newStakingToken), address(newRewardsToken));
        assertEq(address(pool.stakingToken()), address(newStakingToken));
        assertEq(address(pool.rewardsToken()), address(newRewardsToken));
    }

    function test_P_stake() public {
        mintAndApproveToken(alice);
        vm.prank(alice);
        pool.stake(10);
        assertEq(pool.totalSupply(), 10);
    }

    function test_P_withdraw() public {
        stakingToken.mint(alice, 100);
        vm.prank(alice);
        stakingToken.approve(address(pool), 10);
        vm.prank(alice);
        pool.stake(10);
        vm.prank(alice);
        pool.withdraw(5);
        assertEq(pool.totalSupply(), 5);
    }

    function test_P_earned() public {
        // set the variable value
        updateVariable();

        uint256 earn = pool.earned(alice);
        assertEq(earn, 40);
    }

    function test_P_getReward() public {
        // set the variable value
        updateVariable();
        vm.prank(alice);
        pool.getReward();
        uint256 balance = rewardsToken.balanceOf(alice);
        assertEq(balance, 40);
    }

    function test_P_setRewardsDuraton() public {
        pool.setRewardsDuration(100);
        assertEq(pool.duration(), 100);
    }

    function test_P_notifyRewardAmount() public {
        // set the variable value
        pool.setRewardsDuration(50);
        rewardsToken.mint(address(pool), 1000);
        mintAndApproveToken(alice);
        vm.prank(alice);
        pool.stake(100);

        pool.notifyRewardAmount(100);
        assertEq(pool.rewardRate(), 2);
        assertEq(pool.finishAt(), block.timestamp + 50);
        assertEq(pool.updatedAt(), block.timestamp);
    }

    function test_P_getBalanceOfContract() public {
        // set the variable value
        updateVariable();

        uint256 balance = pool.getBalanceOfContract();
        assertEq(balance, 1000);
    }

    function test_P_withdrawRewardToken() public {
        // set the variable value
        updateVariable();

        vm.expectRevert("still product rewardToken");
        pool.withdrawRewardToken();

        vm.warp(block.timestamp + 100);
        pool.withdrawRewardToken();
        uint256 balance = rewardsToken.balanceOf(pool.owner());
        assertEq(balance, 1000);
    }

    function mintAndApproveToken(address user) private {
        stakingToken.mint(user, 100);
        vm.prank(user);
        stakingToken.approve(address(pool), 100);
    }

    function updateVariable() private {
        // set the variable value
        pool.setRewardsDuration(50);
        rewardsToken.mint(address(pool), 1000);
        mintAndApproveToken(alice);
        vm.prank(alice);
        pool.stake(100);
        pool.notifyRewardAmount(100);
        vm.warp(block.timestamp + 20);
        // 可以得到
        // rewardRate = 2
        // duration = 100
        // finishAt = block.timestamp + 100
        // updateAt = block.timestamp
        // rewardPerToken = 4e17
        // rewards[alice] = 40 (即 earned(alice) = 40)
    }
}

