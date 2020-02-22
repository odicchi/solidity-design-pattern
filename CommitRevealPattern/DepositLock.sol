pragma solidity ^0.5.16;

contract DepositLock {

    enum Stages {
        AcceptsingDeposits,
        FreezingDeposits,
        ReleasingDeposits
    }

    Stages public stage = Stages.AcceptsingDeposits;

    uint public creationTime = now;

    mapping(address => uint ) balances;

    modifier atStage(Stages _stage) {
        require(stage == _stage);
        _;
    }

    modifier timedTransactions() {
        if(stage == Stages.AcceptsingDeposits && now >= creationTime + 3 minutes) 
            nextStage();
        if(stage == Stages.FreezingDeposits && now >= creationTime + 5 minutes) 
            nextStage();
        _;
    }

    function nextStage() internal {
        stage = Stages(uint(stage) + 1);
    }

    function deposit() public payable timedTransactions atStage(Stages.AcceptsingDeposits) {
        balances[msg.sender] += msg.value;
    }

    function withDraw() public timedTransactions atStage(Stages.ReleasingDeposits) {
        uint ammount = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(ammount);
    }
}