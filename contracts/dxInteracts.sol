pragma solidity ^0.4.25;

import "@gnosis.pm/dx-contracts/contracts/DutchExchange.sol";
import "@gnosis.pm/util-contracts/contracts/Token.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract dxInteracts is Ownable {
    
    // Address of DutchX exchange contract
    DutchExchange public dx;
    // Wrapped Ether address to handle Ether requests
    Token private weth;
    // whitelisted relayers
    mapping(address => bool) public relayerWhitelist;

    struct Request {
        // address requesting to join auction
        address requester;
        // token provided for auction
        Token provided;
        // token desired from auction
        Token desired;
        // minimum price to join auction
        uint minPrice;
        // maximum price to join auction
        uint maxPrice;
        // signed parametres for transfer function
        bytes signedParametres;
    }
    mapping(uint8 => Request) public requests;

    modifier isWhitelisted(address _addr) {
        require(whitelist[_addr], "Relayer not whitelisted.");
        _;
    }

    constructor(address _dx) 
        public
    {
        require(address(_dx) != address(0), "dutchX address cannot be 0");

        dx = DutchExchange(_dx);

        // rinkeby addresses
        // dx = DutchExchange("0x4e69969d9270ff55fc7c5043b074d4e45f795587");
        weth = Token("0xc778417E063141139Fce010982780140Aa0cD5Ab");
    }

    function addRelayer(address _addr) 
        public
        onlyOwner
    {
        relayerWhitelist[_addr] = true;
    }

    function removeRelayer(address _addr) 
        public
        onlyOwner
    {
        relayerWhitelist[_addr] = false;
    }

    function updateDutchExchange(address _dx) 
        public 
        onlyOwner 
    {
        dx = DutchExchange(_dx);
    }

    function newRequest(
        address _requester,
        address _provided,
        address _desired,
        uint _min,
        uint max,
        bytes signedParametres   
    )
        public
        onlyWhitelist(msg.sender)
    {

    }

    





}