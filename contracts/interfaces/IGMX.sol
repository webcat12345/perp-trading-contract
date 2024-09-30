// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGMX {
    function openPosition(uint256 amount, uint256 leverage) external;
    function closePosition(uint256 positionId) external returns (uint256 pnl);
    function getOpenPositions() external view returns (uint256[] memory);
    function cancelOrder(uint256 orderId) external;
}
