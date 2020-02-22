pragma solidity ^0.5.16;

contract CommitReveal {

    struct Commit {
        string choice;
        string secret;
        string status;
    }

    mapping(address => mapping(bytes32 => Commit)) public userCommits;

    event LogCommit(bytes32, address);
    event LogReveal(bytes32, address, string, string);

    function commit(bytes32 _commit) public returns (bool success) {

        Commit memory userCommit = userCommits[msg.sender][_commit];

        if(bytes(userCommit.status).length != 0) {
            return false;
        }

        userCommit.status = "c";

        emit LogCommit(_commit, msg.sender);

        return true;
    }

    function reveal(string memory _choice, string memory _secret, bytes32 _commit) public returns (bool success) {
        Commit storage userCommit = userCommits[msg.sender][_commit];

        bytes memory bytesStatus = bytes(userCommit.status);

        if(bytesStatus.length == 0) {
            return false;
        } else if(bytesStatus[0] == "r") {
            return false;
        }

        if(_commit != keccak256(abi.encodePacked(_choice, _secret))) {
            return false;
        }

        userCommit.choice = _choice;
        userCommit.secret = _secret;
        userCommit.status = "r";

        emit LogReveal(_commit, msg.sender, _choice, _secret);

        return true;
    }

    function traceCommit(address _address, bytes32 _commit) public view
        returns (string memory choice, string memory secret, string memory status) {

        Commit memory  userCommit = userCommits[_address][_commit];

        require(bytes(userCommit.status)[0] == "r", "Status is Read.");
        return (userCommit.choice, userCommit.secret, userCommit.status);
    }
}