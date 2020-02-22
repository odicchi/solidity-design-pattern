pragma solidity ^0.5.16;

contract CommitRevealElection {
    // The two choices for your vote
    string public choice1;
    string public choice2;

    // Information about the current status of the vote
    uint public votesForChoice1;
    uint public votesForChoice2;
    uint public commitPhaseEndTime;
    uint public numberOfVotesCast = 0;

    // The actual votes and vote commits
    bytes32[] public voteCommits;
    mapping(bytes32 => string) voteStatuses; // Either `Committed` or `Revealed`

    // Events used to log what's going on in the contract
    event logString(string);
    event newVoteCommit(string, bytes32);
    event voteWinner(string, string);

    // Constructor used to set parameters for the this specific vote
    constructor (uint _commitPhaseLengthInSeconds,
                                  string memory _choice1,
                                  string memory _choice2) public {
        if (_commitPhaseLengthInSeconds < 20) {
            revert("Commit time out..");
        }
        commitPhaseEndTime = now + _commitPhaseLengthInSeconds * 1 seconds;
        choice1 = _choice1;
        choice2 = _choice2;
    }

    function commitVote(bytes32 _voteCommit) public {
        if (now > commitPhaseEndTime)
            revert("Only allow commits during committing period");

        // Check if this commit has been used before
        bytes memory bytesVoteCommit = bytes(voteStatuses[_voteCommit]);
        if (bytesVoteCommit.length != 0)
            revert("already commited."); //Bytes vote commit length wrong.

        // We are still in the committing period & the commit is new so add it
        voteCommits.push(_voteCommit);
        voteStatuses[_voteCommit] = "Committed";
        numberOfVotesCast ++;
        emit newVoteCommit("Vote committed with the following hash:", _voteCommit);
    }

    function revealVote(string memory _vote, bytes32 _voteCommit) public{
        if (now < commitPhaseEndTime)
            revert("Only reveal votes after committing period is over");

        // FIRST: Verify the vote & commit is valid
        bytes memory bytesVoteStatus = bytes(voteStatuses[_voteCommit]);
        if (bytesVoteStatus.length == 0) {
            emit logString('A vote with this voteCommit was not cast');
        } else if (bytesVoteStatus[0] != 'C') {
            emit logString('This vote was already cast');
            return;
        }

        if (_voteCommit != keccak256(abi.encodePacked(_vote))) {
            emit logString('Vote hash does not match vote commit');
            return;
        }

        // NEXT: Count the vote!
        bytes memory bytesVote = bytes(_vote);
        if (bytesVote[0] == '1') {
            votesForChoice1 = votesForChoice1 + 1;
            emit logString('Vote for choice 1 counted.');
        } else if (bytesVote[0] == '2') {
            votesForChoice2 = votesForChoice2 + 1;
            emit logString('Vote for choice 2 counted.');
        } else {
            emit logString('Vote could not be read! Votes must start with the ASCII character `1` or `2`');
        }
        voteStatuses[_voteCommit] = "Revealed";
    }

    function getWinner () public returns(string memory _choice) {
        if (now < commitPhaseEndTime)
            revert("Not counting time");
        // Make sure all the votes have been counted
        if (votesForChoice1 + votesForChoice2 != voteCommits.length)
            revert("There was an invalid votes.");

        if (votesForChoice1 > votesForChoice2) {
            emit voteWinner("And the winner of the vote is:", choice1);
            return choice1;
        } else if (votesForChoice2 > votesForChoice1) {
            emit voteWinner("And the winner of the vote is:", choice2);
            return choice2;
        } else if (votesForChoice1 == votesForChoice2) {
            emit voteWinner("The vote ended in a tie!", "");
            return "It was a tie!";
        }
    }
}