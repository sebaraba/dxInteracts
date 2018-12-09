pragma solidity ^0.4.24;

import "@gnosis.pm/dx-contracts/contracts/DutchExchange.sol";
import "@gnosis.pm/util-contracts/contracts/Token.sol";
import "./utils/RelayWhitelist.sol";

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
        // volume of provided token
        uint providedAmount;
        // token desired from auction
        Token desired;
        // minimum price to join auction
        uint minPrice;
        // maximum price to join auction
        uint maxPrice;
        // signed parametres for transfer function
        bytes signedParametres;
    }
    // Request[] public requests;
    mapping(uint16 => Request) public requests;
    uint16 private nonce;
    uint16[] activeRequests;
    

    /**
      * Constructor for dutchX interaction service.
      *
      * @param _dx Address of DutchExchange contract
     */
    constructor(address _dx) 
        public
    {
        nonce = 0;
        require(address(_dx) != address(0), "dutchX address cannot be 0");

        dx = DutchExchange(_dx);

        // rinkeby addresses
        // dx = DutchExchange(0x4e69969d9270ff55fc7c5043b074d4e45f795587);
        weth = Token(0xc778417E063141139Fce010982780140Aa0cD5Ab);
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
        uint _providedAmount,
        address _desired,
        uint _min,
        uint _max,
        bytes _signedParametres   
    )
        public
        onlyWhitelist(msg.sender)
    {
        require(nonce + 1 > nonce, "Nonce overflow");

        requests[nonce] = Request(_requester, Token(_provided), _providedAmount, Token(_desired), _min, _max, _signedParametres);
        emit NewRequest(_requester, _provided, _desired, _min, _max);

        processRequest(nonce);
        nonce = nonce + 1;

        
    }

    /**
      * Process request
      * @param _id Identifier for request to be processed
     */
    function processRequest(uint16 _id) 
        internal
    {
        Request rq = requests[_id];

        /*
        // execute transaction provided by user
        rq.provided.transfer(rq.signedParametres);
        */

        approveOnDx(rq.provided, rq.providedAmount);
        emit RequestProcessed(_id);
    }

    /**
      * Approves ERC-20 for dutchX
     */
    function approveOnDx(address _token, uint _amount) 
        internal 
        returns (bool success)
    {
        require(_amount > 0, "approve amount for dutchX must be positive");
        require(Token(_token).approve(dx, _amount), "approve token for dutchX not successful");

        success = true;
    }

    event NewRequest(
        address indexed _requester,
        address indexed _provided,
        address indexed _desired,
        uint _min,
        uint _max
    );

    event RequestProcessed(
        uint _id
    );
    
}