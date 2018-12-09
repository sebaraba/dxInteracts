pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract RelayWhitelist is Ownable {
    
    modifier onlyWhitelist(address _addr) {
        require(relayerWhitelist[_addr], "Relayer not whitelisted.");
        _;
    }

    mapping(address => bool) public relayerWhitelist;

    event RelayerAdded ( address indexed _address);
    event RelayerRemoved ( address indexed _address);

    function addRelayer(address _addr) 
        public
        onlyOwner
    {
        relayerWhitelist[_addr] = true;
        emit RelayerAdded(_addr);
    }

    function removeRelayer(address _addr) 
        public
        onlyOwner
    {
        relayerWhitelist[_addr] = false;
        emit RelayerRemoved(_addr);
    }
}