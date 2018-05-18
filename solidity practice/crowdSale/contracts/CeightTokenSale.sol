pragma solidity ^0.4.23;

import "./CeightToken.sol";
import "./CeightTokenWhitelist.sol";
// import "./SafeMath.sol";;
import "zeppelin-solidity/contracts/math/SafeMath.sol";

contract CeightTokenSale {
    uint public constant HONGS_PER_WEI = 10000000;
    uint public constant HARD_CAP = 500000000000000;
    CeightToken public token;
    CeightTokenWhitelist public whitelist;
    uint public hongsRaised;
    bool private closed;
    using SafeMath for uint256;

    constructor (
        CeightToken _token, 
        CeightTokenWhitelist _whitelist
    ) public {
        require(_token != address(0));
        token = _token;
        whitelist = _whitelist;
    }

    function () external payable {
        require(!closed);
        require(msg.value != 0);        
        require(whitelist.isRegistered(msg.sender));

        uint hongsToTransfer = msg.value.mul(HONGS_PER_WEI);
        uint weisToRefund = 0;
        if (hongsRaised + hongsToTransfer > HARD_CAP) {
            hongsToTransfer = HARD_CAP - hongsRaised;
            weisToRefund = msg.value - hongsToTransfer.div(HONGS_PER_WEI);
            closed = true;
        }
        hongsRaised = hongsRaised.add(hongsToTransfer);
        if (weisToRefund > 0) {
            msg.sender.transfer(weisToRefund);
        }

        token.transfer(msg.sender, hongsToTransfer);
    }
}