pragma solidity ^0.4.21;

//(생략)
// (1) 에스크로
contract Escrow {
    // (2) 상태변수
    CeightToken public token; // 토큰
    uint256 public salesVolume; // 판매량
    uint256 public sellingPrice; // 판매 가격
    uint256 public deadline; // 기한
    bool public isOpened; // 에스크로 개시 플래그

    // (3) 이벤트 알림
    event EscrowStart(uint salesVolume, uint sellingPrice, uint deadline, address beneficiary);
    event ConfirmedPayment(address addr, uint amount);

    // (4) 생성자 
    function Escrow (CeightToken _token, uint256 _salesVolume, uint256 _priceInEther) public {
        token = CeightToken(_token);
        salesVolume = _salesVolume;
        sellingPrice = _priceInEther * 1 ether;
    }

    // (5) 이름 없는 함수 (Ether 수령)
    function () public payabe {
        // 개시 전 또는 기한이 끝난 경우에는 예외 처리
        if (!isOpened || now >= deadline) revert();

        // 판매 가격 미만인 경우 예외 처리
        uint amount = msg.value;
        if (amount < sellingPrice) revert();

        // 보내는 사람에게 토큰을 전달하고 에스크로 개시 플래그를 false로 설정
        token.transfer(msg.sender, salesVolume);
        isOpened = false;
        ConfirmedPayment(msg.sender, amount);
    }

    // (6) 개시 (토큰이 예정 수 이상이라면 개시)
    function start(uint256 _durationInMinutes) public onlyOwner {
        if (token == address(0) || salesVolume == 0 || sellingPrice == 0 || deadline != 0) revert();
        if (token.balanceOf(this) >= salesVolume){
            deadline = now + _durationInMinutes * 1 minutes;
        isOpened = true;
        EscrowStart(salesVolume, sellingPrice, deadline, owner); 
        }
    }

    // (7) 남은 시간 확인용 메서드 (분 단위)
    function getRemainingTime() constant public returns(uint min) {
        if (now < deadline) {
            min = (deadline - now) / (1 minutes);
        }
    }

    // (8) 종료
    function close() public onlyOwner {
        // 토큰을 소유자에게 전송
        token.transfer(owner, token.balanceOf(this));
        // 계약을 파기 (해당 계약이 보유하고 있는 Ehter는 소유자에게 전송)
        selfdestruct(owner);
    }
}