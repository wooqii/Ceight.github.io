pragma solidity ^0.4.21;
// 계약을 배포한 사람만 블랙리스트를 관리할 수 있다.
// 블랙리스트 기록주소는 입출금 불가, 소유자만 추가삭제 가능, 소유자는 계약배포자의 주소임 // 블랙리스트 기능을 추가한 토큰계약


contract CeightToken {
    // (1) 상태 변수 선언
    string public name; // 토큰 이름
    string public symbol; // 토큰 심볼
    uint8 public decimals; // 소수점 이하 자릿수
    uint256 public totalSupply; // 토큰 총량
    mapping (address => uint256) public balanceOf; // 각 주소의 잔고
    mapping (address => int8) public blackList;  // 블랙리스트
    address public owner; // 소유자 주소

    // (2) 수식자
    modifier onlyOwner() { if (msg.sender != owner) revert(); _;}
    
    // (3) 이벤트 알림
    event Transfer(address indexed from, address indexed to, uint256 value);
    // 이벤트는 트랜잭션의 로그를 출력하는 기능이다. event 뒤에 이벤트 이름을 선언한다. 지갑이 계약 중발생한 처리를 추적하게 한다.
    event Blacklisted(address indexed target);
    event DeletedFromBlacklist(address indexed target);
    event RejectedPaymentToBlacklistedAddr(address indexed from, address indexed to, uint256 value);
    event RejectedPaymentFromBlacklistedAddr(address indexed form, address indexed to, uint256 value);

    // (4) 생성자
    function CeightToken(uint256 _supply, string _name, string _symbol, uint8 _decimals) public {
        balanceOf[msg.sender] = _supply;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _supply;
        owner = msg.sender; // 소유자 주소 설정
    }
    
    // (5) 주소를 블랙리스트에 등록
    function blacklisting(address _addr) public {
        blackList[_addr] = 1;
        emit Blacklisted(_addr);
    }

    // (6) 주소를 블랙리스트에서 제거
    function deleteFromBlacklist(address _addr) public {
        blackList[_addr] = -1;
        emit DeletedFromBlacklist(_addr);
    }

    // (7) 송금
    function transfer(address _to, uint256 _value) public {
        // (8) 부정송금 확인
        if (balanceOf[msg.sender] < _value) revert();  // 계약 실행 주소의 잔고를 확인해 송금액보다 적은 경우 예외처리한다.
        if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // if 구문은 송금으로 인한 오버플로우가 없는 지 확인하는 것이다

        // 블랙리스트에 존재하는 주소는 입출금 불가
        if (blackList[msg.sender] > 0) {
            emit RejectedPaymentFromBlacklistedAddr(msg.sender, _to, _value);
        } else if (blackList[_to] > 0) {
            emit RejectedPaymentToBlacklistedAddr(msg.sender, _to, _value);
        } else {
    // (9) 송금하는 주소와 송금받는 주소의 잔고 갱신
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        }
    
        // (10) 이벤트 알림
        emit Transfer (msg.sender, _to, _value);
    }
}
