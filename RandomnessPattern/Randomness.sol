pragma solidity ^0.5.16;

contract Randomness {

    bytes32 sealedSeed;
    bool seedSet = false;
    bool betsClosed = false;
    bool betMade = false;
    uint storedBlockNumber;
    address trustedParty = 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF;

    event notification(uint);
    
    function setSealedSeed(bytes32 _sealedSeed) public {
        require(!seedSet);
        require (msg.sender == trustedParty);
        betsClosed = true;
        sealedSeed = _sealedSeed;
        storedBlockNumber = block.number + 1;
        seedSet = true;
    }

    function bet() public view{
        require(!betsClosed);
        // Make bets here
    }

    function reveal(bytes32 _seed) public {
        require(seedSet);
        require(betMade);
        require(storedBlockNumber < block.number);
        require(keccak256(abi.encodePacked(msg.sender, _seed)) == sealedSeed);
        uint random = uint(keccak256(abi.encodePacked(_seed, blockhash(storedBlockNumber))));
        // Insert logic for usage of random number here;
        seedSet = false;
        betsClosed = false;
        random = random % 10;
        emit notification(random);
    }
}