pragma solidity ^0.4.25;

import "@gnosis.pm/dx-contracts/contracts/DutchExchange.sol";
import "@gnosis.pm/util-contracts/contracts/Token.sol";
import "utils/EventsDxInteracts.sol";
import "utils/RelayWhitelist.sol";

contract dxInteracts is  RelayWhitelist {
    
    // Address of DutchX exchange contract
    DutchExchange public dx;
    // Wrapped Ether address to handle Ether requests
    Token private weth;

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
    // mapping(uint8 => Request) public requests;
    Request[] public requests;

    /**
      * Constructor for dutchX interaction service.
      *
      * @param _dx Address of DutchExchange contract
     */
    constructor(address _dx) 
        public
    {
        super();
        require(address(_dx) != address(0), "dutchX address cannot be 0");

        dx = DutchExchange(_dx);

        // rinkeby addresses
        // dx = DutchExchange("0x4e69969d9270ff55fc7c5043b074d4e45f795587");
        weth = Token("0xc778417E063141139Fce010982780140Aa0cD5Ab");
    }

    function updateDutchExchange(address _dx) 
        public 
        onlyOwner 
    {
        dx = DutchExchange(_dx);
    }

    function newRequest (
        address _requester,
        address _provided,
        address _desired,
        uint _min,
        uint _max,
        bytes _signedParametres   
    )
        public
        onlyWhitelist(msg.sender)
    {
        requests.push(Request(_requester, _provided, _desired, _min, _max, _signedParametres));
        emit NewRequest(_requester, _provided, _desired, _min, _max);
    }

    





}