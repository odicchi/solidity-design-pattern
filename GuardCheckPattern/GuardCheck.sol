pragma solidity ^0.5.16;

contract GuardCheck {
    
    function donate(address payable addr) payable public {
        require(addr != address(0), "address");
        require(msg.value != 0, "Value");
        uint balanceBeforeTransfer = address(this).balance;
        uint transferAmount;
        
        if (addr.balance == 0) {
            transferAmount = msg.value;
        } else if (addr.balance < msg.sender.balance) {
            transferAmount = msg.value / 2;
        } else {
            revert("revert function");
        }
        
        addr.transfer(transferAmount);
        assert(address(this).balance == balanceBeforeTransfer - transferAmount);      
    }
}