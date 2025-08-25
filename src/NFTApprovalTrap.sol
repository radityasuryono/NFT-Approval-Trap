// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

contract NFTApprovalTrap is ITrap {
    address private owner;

    constructor(address _owner) {
        require(_owner != address(0), "Invalid owner");
        owner = _owner;
    }

    function collect() external view override returns (bytes memory) {
        return abi.encode(owner, block.timestamp, address(this));
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length == 0) {
            return (false, "");
        }

        for (uint i = 0; i < data.length; i++) {
            if (data[i].length != 128) {  
                continue;
            }

            (address nftOwner, address operator, bool approved, uint256 timestamp) =
                abi.decode(data[i], (address, address, bool, uint256));

            if (approved && operator != nftOwner) {
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

        return (false, "");
    }
}
