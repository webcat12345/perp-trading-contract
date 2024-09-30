// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Vault.sol";
import "./interfaces/IGMX.sol";

contract Trading {
    Vault public vault;
    IGMX public gmx;
    address public authorizedTrader;

    event TradeOpened(address indexed trader, uint256 amount, uint256 leverage);
    event TradeClosed(address indexed trader, uint256 pnl);

    constructor(address _vault, address _gmx) {
        vault = Vault(_vault);
        gmx = IGMX(_gmx);
    }

    modifier onlyAuthorized() {
        require(msg.sender == authorizedTrader, "Not authorized");
        _;
    }

    // Set authorized trader (Only owner of vault can set)
    function setAuthorizedTrader(address _trader) external {
        require(msg.sender == vault.owner(), "Not vault owner");
        authorizedTrader = _trader;
    }

    // Open a trade on GMX with funds from the vault
    function openTrade(uint256 amount, uint256 leverage) external onlyAuthorized {
        require(vault.totalDeposits() >= amount, "Insufficient vault funds");

        // Interact with GMX to open leveraged trade
        gmx.openPosition(amount, leverage);

        emit TradeOpened(msg.sender, amount, leverage);
    }

    // Close the trade on GMX and return PnL to vault
    function closeTrade(uint256 positionId) external onlyAuthorized {
        uint256 pnl = gmx.closePosition(positionId);

        // Send PnL back to vault if profitable
        if (pnl > 0) {
            vault.receiveProfits(pnl);
        }

        emit TradeClosed(msg.sender, pnl);
    }
}
