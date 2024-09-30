// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "./Vault.sol";

contract Governance is Ownable2Step {
    Vault public vault;

    constructor(address _vault) {
        vault = Vault(_vault);
    }

    // Update performance fee in Vault
    function updatePerformanceFee(uint256 newFee) external onlyOwner {
        vault.setPerformanceFee(newFee);
    }

    // Update lockup period in Vault
    function updateLockupPeriod(uint256 newLockup) external onlyOwner {
        vault.setLockupPeriod(newLockup);
    }
}
