// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

contract NFTApprovalTrap is ITrap {
    address private owner;
    
    constructor() {
        owner = 0x742d35cC6734c0532925a3b8D2c2e57c9e5f8888; // Address wallet
    }
    
    function collect() external view override returns (bytes memory) {
        return abi.encode(owner, block.timestamp, address(this));
    }
    
    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length == 0) {
            return (false, "");
        }
        
        for (uint i = 0; i < data.length; i++) {
            (address nftOwner, address operator, bool approved, uint256 timestamp) = abi.decode(data[i], (address, address, bool, uint256));
            
            if (approved) {
                if (operator != nftOwner) {
                    bytes memory response = abi.encode(
                        "TRAP_TRIGGERED",
                        "ApprovalForAll detected to external operator",
                        nftOwner,
                        operator,
                        timestamp
                    );
                    return (true, response);
                }
            }
        }
        
        return (false, "");
    }
}