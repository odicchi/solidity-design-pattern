pragma solidity ^0.5.16;

contract AccessRestriction {

    address payable public owner = msg.sender;
    uint public lastOwnerChange = now;
    mapping(address => uint) balanceOf;
    
    modifier onlyBy(address _account) {
        require(msg.sender == _account);
        _;
    }
    
    modifier onlyAfter(uint _time) {
        require(now >= _time);
        _;
    }
    
    modifier costs(uint _amount) {
        require(msg.value >= _amount);
        _;
        if (msg.value > _amount) {
            owner.transfer(_amount);
            msg.sender.transfer(msg.value - _amount);
        }
    }
    
    function changeOwner(address payable _newOwner) public onlyBy(owner) {
        owner = _newOwner;
    }
    
    function buyContract() public payable onlyAfter(lastOwnerChange + 1 minutes) costs(1 ether) {
        owner = msg.sender;
        lastOwnerChange = now;
    }
}