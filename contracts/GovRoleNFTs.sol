// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract IssueRoleNFTs is ERC1155 {
    uint256 public constant Director = 1;
    uint256 public constant Member = 2;
    uint256 public constant Beneficiary = 3;
    // For hackathon Proof-of-Concept purposes, the addresses are stored as an array in the contract
    // In production, this will be moved to off-chain database, or use a third-party indexer service to get list of addresses with a role type NFT 
    address[] private allParticipantsArr; 
    uint256[] private rolesArr;
    mapping(uint256 role => uint256) private rolesCounter;

    // token metadata blank for now; will upload {id}.json to IPFS
    constructor(address[] memory _to, uint256[] memory _ids) ERC1155("") {
        require(_to.length == _ids.length, "length of participants array and roles array must be same");
        allParticipantsArr = _to;
        rolesArr = _ids;
        for (uint256 i = 0; i < _to.length; ++i) {
            rolesCounter[_ids[i]] += 1;
            _mint(_to[i], _ids[i], 1, "");
        }        
    }

    function totalParticipants() public view virtual returns (uint256) {
        return allParticipantsArr.length;
    }

    function roleCount(uint256 roleId) public view virtual returns (uint256) {
        return rolesCounter[roleId];
    }

    function getRoleByAddress(address walletAddress) public view virtual returns (uint256) {
        for (uint256 i = 0; i < allParticipantsArr.length; ++i) {
            if (allParticipantsArr[i] == walletAddress) {
                return rolesArr[i];
            }
            return 0;
        }          
    }
}