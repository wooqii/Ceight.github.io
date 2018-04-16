pragma solidity ^0.4.21; //0.4.0 솔리디티의 버전. 솔리디티는 프라그마 솔리디티를 반드시 버전명과 함께 명시해야함

// 이것은 주석입니다.
contract example { //example 은 임의의 스마트계약 이름
    int value; //상태변수 - 상태변수가 바로 계약계정의 storage이다.

    function example () { //생성자 - 특수한 함수로 계약배포시 최초 한번 실행 됨
        value = 0; // 선언한 상태변수를 0으로 초기화
        } //생성자는 계약 이름과 동일한 함수로써 최초 배포시에만 수행된다. 반드시 필요하지는 않음
    function doNothing () public { //함수. 함수는 이름과 파라미터(인수), 반환값을 가지는데 이중 파라미터와 반환값이 필수는 아님
    // 아무것도 하지 않음
    }
}
    function Calculator () public {
        int sum; //상태변수
        
        function sum(int a, int b) { //두 개의 정수형 파라미터를 갖는 함수
            sum = a + b;
            }

        function sumAndReturn(int a, int b) returns (int) {
            sum = a + b;
            return sum;
            // 또한 함수는 반환값을 가질 수 있는데, 파라미터와 반환값의 형태를 합쳐서 함수의 시그니쳐라고 한다.
            // 위 코드에서 sumAndReturn 함수의 시그니처는 (int, int) return (int) 로써 이 정보만 있으면
            // 함수에 어떤 파라미터를 전달해줘야 하며 그 결과로 어떤 종류의 값이 반환되는지 알 수 있다.
            // 즉, 함수의 사용법을 나타낸 것이 시그니처이다.
        }
        // bool 데이터는 true, false 둘중의 하나의 값만 가진다.
        // 정수를 나타내는것은 부호가 있는 int, uint 두가지가 있고 크기에 따라 int8, uint256 등이 있다.
        // address 데이터는 20바이트의 이더리움 주소를 저장 할 수 있고 몇가지 추가기능이 있다.
        // ㄴbalance : 해당 주소의 잔액을 가져온다
        // ㄴtransfer : 해당 주소롤 이더를 전송한다.
        // ㄴcall :  다른 계약의 기능을 호출 할 때 사용한다.
        // 문자열 string 데이터는 ""로 둘러싸인 어떤 문자열도 저장 가능하다.
        // Array 배열 : 다른 자료형이 중첩된 형태의 배열이다. int[]는 정수배열, address[]는 주소배열
        // *mapping : 배열은 데이터가 일렬로 저장되지만 사상은 키, 값으로 이루어진 쌍이 일렬로 저장된다
        // e.g. mapping(address => uint) 와 같이 선언한다.
        // struct : 구조체 서로 다른 자료형의 데이터 여러개를 포함하는 커스텀한 자료형 생성가능
    struct dataExample {
        bool boolean; // true, false
        uint unsignedInteger; // 부호없는 정수
        int interger; // 부호있는 정수
        int8 int8bits; // 8비트의 정수
        uint256 unsignedInt256bits; // 256비트의 부호없는 정수
        address unknownsAddress; // 어떤이의 주소
        string str; // 문자열
    }
    function dataExample1() {
        boolean = true;
        unsignedInterger = 123;
        interger = -123456;
        int8bits = 127;
        unsignedInt256bits = 12345678901234567890;
        unknownsAddress = 0x62b6f91afc3b85085315c526ab221253addd6879;
        str = "어떤 문자열이든 올 수 있습니다."
    }
    function Mycontract {
        int a;
        function conditionAndLoop(int newA) {
            if (newA == 1) { //if 와 else 조건문은 특정조건이 만족할 때 수행할 코드와 만족하지 않을 때 코드를 작성할 수 있다.
                a = newA;
            } else {
                a = 0;
            }
            while (a < 20) { //while 반복문을 사용하면 특정 조건이 만족될 때에만 반복하는 코드를 작성할 수 있다.
                a = a + 1;
            }
        }
        function sum(int limit) return (int) {
            a = 0;
            for (var i = 0; i < limit; i++) { //for 반복문을 사용하면 적은 코드로 조건을 만족시킬때에만 반복해서 수행하는 코드를 작성할 수 있다.
                a = a + 1;
            }
            return a;
        }
    }
}
contract DataTypeSample { // 솔리디티 데이터타입 샘플
    function getValueType() public view returns (uint) {
        uint a;  // uint형 변수 a를 선언. 이 시점에서 a는 0으로 초기화된다.
        a = 1; // a의 값이 1이 도니다.
        uint b = a; // 변수 a에 a의 값 1이 대입
        b = 2; // b의 값이 2가 된다.
        return a; // a의 값인 1이 반환
    }
    function getReferenceType() public view return (uint[2]) {
        uint[2] a; // uint 형식을 가진 배열 변수 a 를 선언
        a[0] = 1; // 배열의 첫 번째 요소의 값에 1을 대입
        a[1] = 2; // 배열의 두 번째 요소의 값에 2를 대입
        uint[2] b = a; // uint 형식을 가진 배열 변수 b를 선언하고 a를 b에 대입. a는 데이터 영역 주소이기 때문에 b는 a와 동일한 데이터 영역을 참조함
        b[0] = 10; // b와 a는 같은 데이터 영역을 참조하기 때문에 a[0]도 10이 된다.
        b[1] = 20; // 마찬가지로 a[1]도 20이 된다.
        return a; // 10, 20 이 반환된다.
    }
}
contract IntSample {
    function division() public view returns (uint) {
        uint a = 3;
        uint b = 2;
        uint c = a / b * 10 // a / b의 결과는 1이다
        return c; // 10이 반환된다.
    }
    function divisionLiterals() public view returns (uint) {
        uint c = 3 / 2 * 10; // 상수이기 때문에 a / b의 나머지를 버리지 않는다 즉 1.5가 된다.
        return c; // 15를 반환한다.
    }
    function divisionByZero() public view returns (uint) {
        uint a = 3;
        uint c = a / 0;  //컴파일 되지만 실행시 예외가 발생한다.
        return c; // uint c = 3 / 0 으로 하면 컴파일도 진행되지 않는다.
    }
    function shift() public view returns (uint[2]) {
        uint[2] a;
        a[0] = 16 << 2; // 16 * 2 ** 2 = 64
        a[1] = 16 >> 2; // 16 / 2 ** 2 = 4
        return a; // 64, 4가 반환된다.
    }
}
contract AddressSample { //주소 샘플. 이름없는 함수(송금되면 실행) payable을 지정해 Ether를 받을 수 있다.
    function () payable {}
    function getBalance(address _target) public view returns(uint) {
        if (_target == address(0)) {  // _target이 0인 경우 계약 자신의 주소를 할당
            _target = this;
        }
        return _target.balance;  //잔고반환.
    }
    // 이후 송금 메서드를 실행하기 전 이 계약에 대해 송금해둬야 한다.
    // 인수로 지정된 주소에 transfer를 사용해 송금
    function send(address _to, uint _amount) {
        if (!_to.send(_amount)) { //send를 사용할 경우 반환값을 체크해야 한다.
        }
    }
    // 인수로 지정된 주소에 call을 사용해 송금
    function call(address _to, uint _amount) {
        if (! _to.call.value(_amount).gas(1000000)()) {  //call도 반환값을 체크해야한다.
        }
    }
    // 인출 패턴(transfer)
    function withdraw() {
        address to = msg.sender; // 메서드 실행자를 받는 사람으로 한다.
        to.transfer(this.balance); //전액 송금한다.
    }
    // 인출 패턴 (call)
    function withdraw2() {
        address to = msg.sender; // 메서드 실행자를 받는 사람으로 한다.
        if (!to.call.value(this.balance).gas(1000000)()) { //전액 송금한다
        }
    }
}
contract ArraySample {
    uint[5] public fArray = [uint(10), 20, 30, 40, 50];  //고정 길이 배열의 선언 및 초기화
    uint[] public dArray; // 가변 길이 배열 선언
    function getFixedArray() public view returns(uint[5]) {
        uint[5] storage a = fArray; //길이가 5인 고정 배열을 선언
        //메서드 안에서는 이 형식으로 초기화할 수 없다.
        // uint[5] b =[uint[1], 2, 3, 4, 5]
        for (uint i = 0; i < a.length; i++) {  //초기화
            a[i] = i + 1;
        }
        return a;  // [1, 2, 3, 4, 5]를 반환
    }
    function getFixedArray() public view returns(uint[5]) {
        uint[5] storage b = fArray; //상태변수 초기화
        return b; // [10, 20, 30, 40, 50] 을 반환
    }
}
contract BasicContract { //상속을 당하는 계약
    int a;
    function getA() returns (int) {
        return a;
    }
}
contract BetterContract is BasicContract {// 상속할 때는 is 키워드를 사용한다.
    int b;
    function getAPlusB() returns (int) {
        var basicA = getA();
        return basicA + b;
    }
}
contract ClientReceipt { //이벤트 : 함수 수행이 블록체인에 기록될 때, 어떤 사건을 주시하는 코드 - 주시하고 알려줌
    event Deposit(address indexed _from, bytes32 indexed _id, uint _value);
    function deposit(bytes32 _id) {
        Deposit(msg.senderm _id, msg.value); //이벤트를 생성하는 코드
    }
    // block.coinbase (address) : 현재 블록 채굴자의 주소
    // block.difficulty (uint) : 현재 블록의 난이도
    // block.gasLimit (uint) : 현재 블록의 총 가스량
    // block.number (uint) :  현재 블록의 넘버
    // block.blockhash(function(uint) returns (bytes32)) : 블록 해시값을 구하는 함수
    // block.timestamp (uint) : 현재 블록의 타임스탬프
    // msg.data (bytes) : 메시지 데이터
    // msg.gas (uint) : 메시지의 Start Gas
    // msg.sender (address) : 현재 메시지를 전송한 계정의 주소 = 발신자
    // msg.value (uint) : 메시지에 포함된 이더의 가격 (Wei 단위)
    // now (uint) : 현재 블록의 타임스탬프
    // tx.gasprice (uint) : 거래의 Gas Price
    // tx.origin (address) : 거래를 전송한 계정의 주소

    // 접근성 명시 
    // Private : 오로지 계약 내에서만 접근 가능함
    // Internal : 해당 계약 혹은 해당 계약을 상속한 지식계약에서 접근가능 (상태변수는 기본적으로 Internal)
    // Public : 해당 계약내에서, 혹은 메시지를 통해서만 오로지 접근 가능 (함수는 기본적으로 public)
    // External : 해당계약 내부 및 외부에서 접근이 가능해서 어떤 거래 혹은 메시지로도 접근이 가능함
}
contract SimpleStorage {
    uint storedData; // 저장소에 값을 기록하는데 20000 wei 가스, 변경시 5000 가스가 소모되는 매우 비싼자원
    function set(uint x) public {
        storedData = x; // 파라미터 혹은 함수 내의 변수는 값을 저장하는데 3가스만 드는 매우 저렴한 자원이지만 영속적이지 않고 오직 계약이 실행되는 순간에만 존재
    }

    function get() public public view returns (uint) {//public view 는 읽기전용.
        return storedData; // 저장소의 값을 읽어올 때에는 200가스가 소모됨
    }
}
contract CoinCeight {
    address public minter; //minter는 토큰 발행자
    mapping (address => uint) public balances; // public 키워드는 계약 바깥에서 해당 상태변수를 볼 수 있도록 허락함
    event Sent(address from, address to, uint amount); //event는 계약 내부에서 일어나서 바깥으로 전달할 사건을 나타냄
    function Coin() public {
        minter = msg.sender; //minter = 발행자 = 계약 작성자 라는 뜻
    }
    function mint(address receiver, uint amount) public { //mint : 발행, receiver : 토큰 받는 주소, amount : 발행량
        if (msg.sender != minter) return; //minter가 아니라면 return; 반환 및 종료
        balances[receiver] += amount; //발행자라면 amount 만큼 증가시켜준다
    }
    function send(address receiver, uint amount) public { //send : 보내기 
        if (balances[msg.sender] < amount) return; // 만약 발행자의 잔액이 발행량보다 작으면 return; 종료
        balances[msg.sender] -= amount; // 발행자의 잔고를 발행량만큼 줄인다.
        balances[receiver] += amount; // 수신자의 잔고를 발행량만큼 늘린다.
        emit Sent(msg.sender, receiver, amount); //emit 키워드는 이벤트를 생성해서 모니터링 하고 있는 노드에게 전달하는 역할을 함
    }
    function queryBalance(address addr) public view returns (uint balance) { //특정주소의 계좌에 해당하는 잔액을 조회
        return balances[addr];
    }
}
// ERC20 이더리움 토큰 표준
contract ERC20Interface {
    function totalSupply() public public view returns (uint);
    function balanceOf(address tokenOwner) public public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
// https://theethereum.wiki/w/index.php/ERC20_Token_Standard#Sample_Fixed_Supply_Token_Contract