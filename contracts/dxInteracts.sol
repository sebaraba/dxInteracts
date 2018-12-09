pragma solidity ^0.4.24;

import "@gnosis.pm/dx-contracts/contracts/DutchExchange.sol";
import "@gnosis.pm/util-contracts/contracts/Token.sol";
import "./utils/RelayWhitelist.sol";

contract dxInteracts is  RelayWhitelist {
    
    // Address of DutchX exchange contract
    DutchExchange public dx;
    // Wrapped Ether address to handle Ether requests
    Token private weth;

    enum RequestState {CREATED, WAITING_FOR_AUCTION, COMPLETE}

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
        // State request is at
        RequestState state;
        // if trade is buy or sell
        bool buy;
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
        bytes _signedParametres,
        bool _buy
    )
        public
        onlyWhitelist(msg.sender)
    {
        require(nonce + 1 > nonce, "Nonce overflow");
        
        requests[nonce] = Request(_requester, Token(_provided), _providedAmount, Token(_desired), _min, _max, _signedParametres, RequestState.CREATED, _buy);
        emit NewRequest(_requester, _provided, _desired, _min, _max, _buy);

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
        if(rq.state == RequestState.CREATED) {
            require(approveOnDx(rq.provided, rq.providedAmount), "Not able to approve tokens for dutchX");
            require(depositOnDx(rq.provided, rq.providedAmount), "Not able to deposit tokens for dutchX");

        } else if(rq.state == RequestState.WAITING_FOR_AUCTION) {
            // require(joinAuction(_id), "Not able to join auction");
            // verification
        } else if(rq.state == RequestState.COMPLETE) {
            // require claim funds
            // verification
        }
        emit RequestProcessed(_id, rq.state);
        progressRequest(_id);
    }

    function progressRequest(uint16 _id)
        internal
    {
        if(requests[_id].state == RequestState.CREATED) {
            requests[_id].state = RequestState.WAITING_FOR_AUCTION;
        } else if(requests[_id].state == RequestState.WAITING_FOR_AUCTION) {
            requests[_id].state = RequestState.COMPLETE;
        }
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

    
    function depositOnDx(Token _token, uint _amount) 
        internal
        returns (bool success)
    {
        require(_amount > 0, "Deposit amount on dutchX must be positive");
        require(_token.allowance(this, dx) >= _amount, "Allowance must be >= amount to deposit on dutchX");
        require(dx.deposit(_token, _amount) >= _amount, "Deposit on dutchx failed");

        emit Deposit(_token, _amount);
        
        success = true;
    }


    function joinAuction(
        uint16 _rqId,
        uint _auctionIndex
    )
        public
        onlyWhitelist(msg.sender)
        returns (bool success)
    {
        Request memory rq = requests[_rqId];
        // TODO : require conditions
        // require that auction be in bounds of request
        //require();
        if(rq.buy) {
            dx.postBuyOrder(rq.provided, rq.desired,_auctionIndex, rq.providedAmount);
        } else {
            dx.postSellOrder(rq.provided, rq.desired,_auctionIndex, rq.providedAmount);
        }

        emit AuctionJoined();
        success = true;
    }

    event NewRequest(
        address indexed _requester,
        address indexed _provided,
        address indexed _desired,
        uint _min,
        uint _max,
        bool _buy
    );

    event RequestProcessed(
        uint _id,
        RequestState state
    );

    event Deposit(
        address indexed token,
        uint amount
    );

    event AuctionJoined(

    );
    
}