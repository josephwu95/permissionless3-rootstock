const { ethers } = require("hardhat");

// For demo purposes, this DAO has 12 addresses (approximating actual human participants)
const demoParticipantsArr = [
  0xaECfCd38967188a2954819D2B6F478Aa7E1E457d, 
  0xC9DB27952F15BfF2c028E565537fe27DA478c029,
  0x0ADb1f591985812c2F2C7b5b809bE14B09Be2D78,
  0xBc139E88e06936f8353c150f17A7F91270c3b32e,
  0x788572d0ff06cc9ab789FC02A9A768503B408B39,
  0xB9d465f0b580ab3445F78582FE764c2B0fF8b3d1,
  0x92b830eA65F5D98e07eD741374b5f16d996e3325,
  0x48675ceDb7601a2757241862099dD6E7eE26b00f,
  0xC1985952317bCAB633486D5DEC8d7488Ca24Ef9e,
  0x993548bCd10F9d482bc6777530F0478fBB31BBfA,
  0x0b342D19CDE2659A54c60f2eaC13139Ccd86989c,
  0x5a1cD27bdf214d9CF4E53e191A98256e5C340465];
const demoRolesArr = [1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3];



function issue_DAO_NFTs {
  const [owner] = await ethers.getSigners();
  const GovRoleNFTs = await ethers.getContractFactory("GovRoleNFTs");
  const govRoleNFTs = await GovRoleNFTs.deploy(demoParticipantsArr, demoRolesArr);
  await govRoleNFTs.deployed();
  return true;
}

function allocate_votes(roleVoteMapping, passThreshold) {
  const votesPerDirector = roleVoteMapping.get(1);
  const votesPerMember = roleVoteMapping.get(2);
  const votesPerBeneficiary = roleVoteMapping.get(3);

  var votesArr = []; 
  for (let i = 0; i < demoRolesArr.length; i++) {
    let currVote = roleVoteMapping.get(demoRolesArr[i]);
    votesArr.push(currVote);
  }

  const [owner] = await ethers.getSigners();
  const VoteTokenRound = await ethers.getContractFactory("VoteTokenRound");
  const voteTokenRound = await VoteTokenRound.deploy(demoParticipantsArr, votesArr, passThreshold);
  await voteTokenRound.deployed();
  return true;
}

