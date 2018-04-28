pragma solidity ^0.4.23;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';

contract CeightToken is StandardToken {
    uint public INITIAL_SUPPLY = 21000000;
    string public name = 'CeightToken';
    string public symbol = 'CEX'
    uint8 public decimals = 18;
    address owner;
    bool public released = false;

    function CeightToken() public {
        totalSupply_ = INITIAL_SUPPLY * 10 ** uint(decimals);
        balances[msg.sender] = INITIAL_SUPPLY;
        owner = msg.sender;
    }

    function release() public {
        require(owner == msg.sender);
        require(!released);
        released = true;
    }

    modifier onlyReleased() {
        require(released);
        _;
    }

    function transfer(address to, uint256 value) public onlyReleased returns(bool) {
        super.transfer(to, value);
    }

    function allowance(Address owner, address spender) public onlyReleased view returns(uint256) {
        super.allowance(owner, spender);
    }

    function transferFrom(address from, address to, uint256 value) public onlyReleased view returns(uint256) {
        super.allowance(from, to, value);
    }

    function approve(address spender, uint256 value) public onlyReleased returns(bool) {
        super.approve(spender, value);
    }
    
}