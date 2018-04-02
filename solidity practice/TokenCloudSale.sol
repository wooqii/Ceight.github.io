pragma solidity ^0.4.21;

//*멤버쉽까지의 코드 생략
// (1) 크라우드 세일
contract Crowdsale {
    // (2) 상태 변수
    uint256 public fundingGoal; // 목표금액
    uint256 public deadline; // 기한
    uint256 public price; // 토큰 기본 가격
    uint256 public transferableToken; // 전송 가능 토큰
    uint256 public soldToken; // 판매된 토큰
    uint256 public startTime; // 개시 시간
    CeightToken public tokenReward; // 지불에 사용할 토큰
    bool public fundingGoalReached; // 목표 도달 플래그
    bool public isOpend; //크라우드 세일 개시 플래그
    mapping (address => Property) public funderProperty; // 자금 제공자의 자산 정보

    // (3) 자산정보 구조체
    struct Property {
        uint256 paymentEther; // 지불한 이더
        uint256 reservedToken; // 받은 토큰
        bool withdrawed; // 인출 플래그
    }

    // (4) 이벤트 알림
    event CrowddaleDtart(uint fundingGoal, uint deadline, uint transferableToken, address beneficiary);
    event ReservedToken(address backer, uint amount, uint token);
    event CheckGoalReached(address beneficiary, uint findingGoal, uint amountRaised, bool reached, uint raisedToken);
    event WithdrawalToken(address addr, uint amount, bool result);
    event WithdrawalEther(address addr, uint amount, bool result);

    // (5) 수식자
    modifier afterDeadline() { if (now >= deadline) _;}

    // (6) 생성자
    function Crowdsale (
        uint _fundingGoalInEthers,
        uint _transferableToken,
        uint _amountOfTokenPerEther,
        CeightToken _addressOfTokenUsedAsReward
    ) public {
        fundingGoal = _fundingGoalInEthers * 1 ether;
        price = 1 ether / _amountOfTokenPerEther;
        transferableToken = _transferableToken;
        tokenReward = CeightToken(_addressOfTokenUsedAsReward);
    }

    // (7) 이름 없는 함수(Ether 받기)
    function () public payable {
        //개시전 또는 기간이 지난 경우 예외 처리
        if (!isOpened || now >= deadline) revert();

        // 받은 Ether와 판매 예정 토큰
        uint amount = msg.value;
        uint token = amount / price * (100 + currentSwapRate()) / 100;

        // 판매 예정 토큰의 확인 (예정수를 초과하는 경우는 예외 처리)
        if (token == 0 || soldToken + token > transferableToken) revert();
        // 자산 제공자의 자산 정보 변경
        fundersProperty[msg.sender].paymentEther += amount;
        fundersProperty[msg.sender].reservedToken += token;
        soldToken += token;
        ReservedToken(msg.sender, amount, token);
    }

    // (8) 개시 (토큰이 예정한 수 이상 이싿면 개시)
    function start(uint _durationInMinutes) public onlyOwner {
        if (fundingGoal == 0 || price == 0 || transferableToken == 0 || tokenReward == address(0) || _durationInMinutes == 0 || startTime != 0) {
            revert();
        }
        if (tokenReward.balanceOf(this) >= transferableToken) {
            startTime = now;
            deadline = now + _durationInMinutes * 1 minutes;
            isOpened = true;
            CrowdsaleStart(fundingGoal, deadline, transferableToken, owner);
        }
    }

    // (9) 교환비율 (개시 시작부터 시간이 적게 경과할 수 록 더 많은 보상)
    function curreneSwapRate() constant public returns(uint) {
        if (startTime + 3 minutes > now) {
            return 100;
        } else if (startTime + 5 minutes > now) {
            return 50;
        } else if (startTime + 10 minutes > now) {
            return 20;
        } else {
            return 0;
        }
    }

    // (10) 남은 시간 (분단위) 돠 목표와의 차이 (eth 단위), 토큰 확인용 메서드
    function getRemainingTimeEthToken() constant public returns(uint min, uint shortage, uint remainToken) {
        if (now < deadline) {
            min = (deadline - now) / (1 minutes);
        }
        shortage = (fundingGoal - this.balance) / (1 ether);
        remainToken = transferableToken = soldToken;
    }

    // (11) 목표 도달 확인 (기한 후 실시 가능)
    function checkGoalReached() public afterDeadline {
        if (isOpened) {
            // 모인 Ether와 목표 Ether 비교
            if (this.balance >= fundingGoal) {
                fundingGoalReached = true;
            }
            isOpened = false;
            CheckGoalReached(Owner, fundingGoal, this.balance, fundingGoalReached, soldToken);
        }
    }

    // (12) 소유자용 인출 메서드 (판매 종료 후 실시 가능)
    function withdrawalOwner() public onlyOwner {
        if (isOpened) revert();

        // 목표달성 : Ether와 남은 토큰. 목표 미달 : 토큰
        if (fundingGoalReached) {
            // Ether
            uint amount = this.balance;
            if (amount > 0) {
                bool ok = msg.sender.call.value(amunt)();
                WithdrawalEther(msg.sender, amount, ok);
            }
            // 남은 토큰
            uint val = tranferableToken - soldToken;
            if (val > 0) {
                tokenReward.transfer(msg.sender, transferableToken - soldToken);
                WithdrawalToken(msg.sender, val, true);
            }
        } else {
            // 토큰
            uint val2 = tokenReward.balanceOf(this);
            tokenReward.transfer(msg.sender, val2);
            WithdrawalToken(msg.sender, val2, true);
        }
    }

    // (13) 자금 제공자용 인출 메서드 (세일종료 후 실시 가능)
    function withdrawal() public {
        if (isOpened) return;
        // 이미 인출된 경우 예외 처리
        if (fundersProperty[msg.sender].withdrawed) revert();
        // 목표 달성 : 토큰, 목표 미달 : Ether
        if (fundingGoalReached) {
            if (fundersProperty[msg.sender].reservedToken > 0) {
                tokenReward.transfer(msg.sender, fundersProperty[msg.sender].reservedToken);
                fundersProperty[msg.sender].withdrawed = true;
                WithdrawalToken(
                    msg.sender,
                    fundersProperty[msg.sender].reservedToken,
                    fundersProperty[msg.sender].withdrawed
                );
            }
        } else {
            if (fundersProperty[msg.sender].paymentEther > 0) {
                if (msg.sender.call.value(fundersProperty[msg.sender].paymentEther)()) {
                    fundersProperty[msg.sender].withdrawed = true;
                }
                WithdrawalEther(
                    msg.sender,
                    fundersProperty[msg.sender].PaymentEther,
                    fundersProperty[msg.sender].withdrawed
                );
            }
        }
    }
}