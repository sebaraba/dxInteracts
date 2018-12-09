pragma solidity ^0.4.25;

contract EventsDxInteracts {
    event NewRequest(
        address indexed _requester,
        address indexed _provided,
        address indexed _desired,
        uint _min,
        uint _max
    );
}