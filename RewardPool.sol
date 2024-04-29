// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IRewardPool } from "./IRewardPool.sol";

/// Issue - Fund Lock Due to Incorrect Balance Reference in withdrawRemainingTokens
/// Solution - fixed typo in withdraw function from balanceOf(msg.sender) to _pooledBudsAmount)
contract RewardPool is Ownable, IRewardPool {
    error UnAuthorized();
    error InsufficientFunds();
    error ZeroAddress(string);

    IERC20 public _budsToken;

    address public _stakeAndRaidContract;

    uint256 public _pooledBudsAmount;

    constructor(address owner, address StakingContract, address budsTokenAddress) Ownable(owner) {
        if (StakingContract == address(0)) revert ZeroAddress("Staking contract address can't be zero");
        if (budsTokenAddress == address(0)) revert ZeroAddress("BudsToken contract address can't be zero");
        _stakeAndRaidContract = StakingContract;
        _budsToken = IERC20(budsTokenAddress);
    }

    modifier onlyStakingContract() {
        if (_msgSender() != _stakeAndRaidContract) revert UnAuthorized();
        _;
    }

    function sendRewards(uint256 amount, address to) external onlyStakingContract {
        if (amount > _pooledBudsAmount) revert InsufficientFunds();
        _pooledBudsAmount -= amount;
        _budsToken.transfer(to, amount);
    }

    function fundPool(uint256 amount) external onlyOwner {
        _pooledBudsAmount += amount;
        _budsToken.transferFrom(_msgSender(), address(this), amount);
    }

    function withdrawRemainingTokens() external onlyOwner {
        _budsToken.transfer(_msgSender(), _budsToken.balanceOf(address(this)));
    }
}
