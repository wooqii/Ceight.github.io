pragma solidity ^0.4.23;

interface token {
    function transfer(address receiver, uint amount) external;
}

contract CrowdFund {
    address public beneficiary; 
    uint public fundingGoal; 
    uint public amountRaised;
    uint public deadline;
    uint public price;
    token public tokenReward;
    mapping (address =>uint256) public balanceOf;
    bool public fundingGoalReached = false;
    bool public crowdsaleClosed = false;

    event GoalReached(address beneficiaryAddress, uint amountRaisedValue );
    event FundTransfer(address backer, uint amount, bool isContribution );

    constructor ( 
        address ifSuccessfulSendTo; //목표금액 달성시 모금액을 받을 어카운트
        uint fundingGoalInEther; //모금할 목표 이더
        uint durationInMinutes; //분으로 환산한 모금기간
        uint etherCostOfEachToken; // 이더와 토큰의 교환 비율
        address addressOfTokenUsedAsReward; //청약보상으로 지급할 토큰컨트랙트 주소
        ) public {
        beneficiary = ifSuccessfulSendTo;
        fundingGoal = fundingGoalInEther * 1 ether;
        deadline = now + durationInMinutes * 1 minutes;
        price = etherCostOfEachToken * 1 ether;
        tokenReward = token(addressOfTokenUsedAsReward);
    }

    function () external payable {
        require(!crowdsaleClosed);
        uint amount = msg.value;
        balanceOf[msg.sender] += amount;
        amountRaised += amount;
        tokenReward.transfer(msg.sender, amount/price);
        emit FundTransfer(msg.sender, amount, true);        
    }

    modifier afterDeadline() {if(now>=deadline)_;}

    function checkGoalRechead() external afterDeadline {
        if (amountRaised >= fundingGoal){
            fundingGoalReached = true;
            emit GoalReached(beneficiary, amountRaised);
        }
        crowdsaleClosed = true;
    }

    function safeWithdrawl() external afterDeadline {
        if (!fundingGoalReached) {
            uint amount = balanceOf[msg.sender];
            balanceOf[msg.sender] = 0;
            if (amount > 0) {
                if (msg.sender.transfer(amount)) {
                    emit FundTransfer(msg.sender, amount, false);
                } else {
                    balanceOf[msg.sender] = amount;
                }
            }
        }
        if (fundingGoalReached && beneficiary == msg.sender) {
            if(beneficiary.transfer(amountRaised)) {
                emit FundTransfer(beneficiary, amountRaised, false);
            } else {
                fundingGoalReached = false;
            }
        }
    }
}