// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IGMX.sol";

contract PositionManager {
    IGMX public gmx;

    constructor(address _gmx) {
        gmx = IGMX(_gmx);
    }

    // Track open positions on GMX
    function trackPositions() external view returns (uint256[] memory) {
        return gmx.getOpenPositions();
    }

    // Cancel a pending order on GMX
    function cancelOrder(uint256 orderId) external {
        gmx.cancelOrder(orderId);
    }
}
