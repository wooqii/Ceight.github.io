pragma solidity ^0.4.21;


contract CeightToken {
    // (1) 상태 변수 선언
    string public name; // 토큰 이름
    string public symbol; // 토큰 심볼
    uint8 public decimals; // 소수점 이하 자릿수
    uint256 public totalSupply; // 토큰 총량
    mapping (address => uint256) public balanceOf; // 각 주소의 잔고

    // (2) 이벤트 알림
    event Transfer(address indexed from, address indexed to, uint256 value);
    // 이벤트는 트랜잭션의 로그를 출력하는 기능이다. event 뒤에 이벤트 이름을 선언한다. 지갑이 계약 중발생한 처리를 추적하게 한다.

    // (3) 생성자
    function CeightToken(uint256 _supply, string _name, string _symbol, uint8 _decimals) public {
        balanceOf[msg.sender] = _supply;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _supply;
    }

    // (4) 송금
    function Transfer(address _to, uint256 _value) public {
        // (5) 부정송금 확인
        if (balanceOf[msg.sender] < _value) revert();  // 계약 실행 주소의 잔고를 확인해 송금액보다 적은 경우 예외처리한다.
        if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // if 구문은 송금으로 인한 오버플로우가 없는 지 확인하는 것이다
        // (6) 송금하는 주소와 송금받는 주소의 잔고 갱신
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        // (7) 이벤트 알림
        emit Transfer (msg.sender, _to, _value);
    }
}