// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VoteTokenRound is ERC20 {
    uint256 public constant VoteRound = 2;    
    bool public passStatus = false;
    uint256 public totalVotesIssued = 0;
    uint256 public passThreshold;
    uint256 public totalVotesCast;
    uint256 public passVoteCounter;

    uint256[] private rolesArr;
    mapping(uint256 role => uint256) private rolesCounter;

    constructor(address[] memory _to, uint256[] memory numVotes, uint256 _passThreshold) ERC20("VoteTokenRound2", "VTR2") {
        require(_to.length == numVotes.length, "length of voters array and votes array must be same"); 
        passThreshold = _passThreshold;
        for (uint256 i = 0; i < _to.length; ++i) {
            totalVotesIssued += numVotes[i];
            _mint(_to[i], numVotes[i]);
        } 
    }

    function submitVotes(uint256 numVotes, bool passFail) public virtual {
        require(balanceOf(msg.sender) >= numVotes, "user must have enough vote tokens to cast the specified number of votes"); 
        _burn(msg.sender, numVotes);
        // if the sender doesn't have enought vote tokens, this function call will error - no state changes
        totalVotesCast += numVotes;
        if (passFail) {
            passVoteCounter += numVotes;
        }
        if (passVoteCounter >= passThreshold) {
            passStatus = true;
        }
    }
}