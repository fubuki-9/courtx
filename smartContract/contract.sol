pragma solidity ^0.8.0;

contract Litigation {
    address payable owner;
    mapping(address => bool) parties;
    mapping(bytes32 => Evidence) evidences;
    struct Evidence {
        bytes32 hash;
        address party;
        bool accepted;
    }

    constructor() public {
        owner = msg.sender;
    }

    function addParty(address party) public {
        require(msg.sender == owner);
        parties[party] = true;
    }

    function addEvidence(bytes32 hash, address party) public {
        require(parties[party] == true);
        evidences[hash] = Evidence(hash, party, false);
    }

    function acceptEvidence(bytes32 hash) public {
        require(msg.sender == owner);
        evidences[hash].accepted = true;
    }

    function viewEvidence(bytes32 hash) public view returns (bytes32, address, bool) {
        return (evidences[hash].hash, evidences[hash].party, evidences[hash].accepted);
    }

    function disputeEvidence(bytes32 hash) public {
        require(evidences[hash].accepted == true);
        delete evidences[hash];
    }

    function grantAccess(address party, bytes32 hash) public {
        require(msg.sender == owner);
        require(evidences[hash].accepted == true);
        evidences[hash].party = party;
    }
}
