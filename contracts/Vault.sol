// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vault is Ownable {
    IERC20 public usdc;
    uint256 public totalDeposits;
    uint256 public performanceFee = 100; // 1% = 100 basis points
    uint256 public lockupPeriod = 1 days;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public depositTimestamps;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event PerformanceFeeChanged(uint256 newFee);
    event LockupPeriodChanged(uint256 newLockup);

    constructor(address _usdc) {
        usdc = IERC20(_usdc);
    }

    // Deposit USDC into the vault
    function deposit(uint256 amount) external {
        require(amount > 0, "Invalid amount");
        usdc.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
        depositTimestamps[msg.sender] = block.timestamp;
        totalDeposits += amount;

        emit Deposited(msg.sender, amount);
    }

    // Withdraw funds from the vault after lockup period
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(block.timestamp >= depositTimestamps[msg.sender] + lockupPeriod, "Lockup period not over");

        balances[msg.sender] -= amount;
        totalDeposits -= amount;
        usdc.transfer(msg.sender, amount);

        emit Withdrawn(msg.sender, amount);
    }

    // Change the performance fee (owner function)
    function setPerformanceFee(uint256 newFee) external onlyOwner {
        performanceFee = newFee;
        emit PerformanceFeeChanged(newFee);
    }

    // Change lockup period (owner function)
    function setLockupPeriod(uint256 newLockup) external onlyOwner {
        lockupPeriod = newLockup;
        emit LockupPeriodChanged(newLockup);
    }

    // Function to receive profits from trading contract
    function receiveProfits(uint256 profitAmount) external onlyOwner {
        totalDeposits += profitAmount;
    }
}
