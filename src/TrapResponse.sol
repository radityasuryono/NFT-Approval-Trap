// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TrapResponse {
    struct TrapAlert {
        string alertType;
        string message;
        address owner;
        address operator;
        uint256 timestamp;
    }
    
    TrapAlert[] public alerts;
    address private trapContract;
    
    constructor() {
    }
    
    function receiveResponse(bytes memory responseData) external {
        if (responseData.length > 0) {
            (string memory alertType, string memory message, address owner, address operator, uint256 timestamp) = 
                abi.decode(responseData, (string, string, address, address, uint256));
            
            alerts.push(TrapAlert({
                alertType: alertType,
                message: message,
                owner: owner,
                operator: operator,
                timestamp: timestamp
            }));
        }
    }
}