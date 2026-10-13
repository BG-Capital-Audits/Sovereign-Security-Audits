// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/**
 * @title InstitutionalTokenLedger
 * @notice Core registry contract designed for institutional asset tracking and balance routing.
 */
contract InstitutionalTokenLedger {

    // --- STATE VARIABLES ---
    address public owner;
    uint256 public immutable totalSupply;
    
    mapping(address => uint256) private balances;

    // --- CUSTOM ERRORS ---
    error UnauthorizedAccess(address caller);
    error DeficitPayload(uint256 requested, uint256 available);

    // --- CONSTRUCTOR ---
    constructor(uint256 initialSupplyPayload) {
        owner = msg.sender; 
        totalSupply = initialSupplyPayload; 
        balances[msg.sender] = initialSupplyPayload; 
    }

    // --- SECURE VIEW FUNCTION ---
    function checkAccountBalance(address account) external view returns (uint256) {
        return balances[account];
    }

    // --- KINETIC INTAKE VALVE ---
    function distributeCapital(address client, uint256 amount) external {
        if (msg.sender != owner) {
            revert UnauthorizedAccess(msg.sender);
        }
        
        if (balances[owner] < amount) {
            revert DeficitPayload(amount, balances[owner]);
        }

        balances[owner] = balances[owner] - amount;
        balances[client] = balances[client] + amount;
    }
}
