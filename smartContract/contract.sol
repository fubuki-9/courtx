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
    bool public stopped;
    event EvidenceAdded(address indexed party, bytes32 indexed hash);
    event EvidenceAccepted(address indexed party, bytes32 indexed hash);
    event EvidenceDisputed(address indexed party, bytes32 indexed hash);
    event AccessGranted(address indexed party, bytes32 indexed hash);
    event EmergencyStop();

    constructor() public {
        owner = msg.sender;
    }

    function addParty(address party) public {
        require(msg.sender == owner);
        require(!stopped);
        parties[party] = true;
    }

    function addEvidence(bytes32 hash, address party) public {
        require(parties[party] == true);
        require(!stopped);
        evidences[hash] = Evidence(hash, party, false);
        emit EvidenceAdded(party, hash);
    }

    function acceptEvidence(bytes32 hash) public {
        require(msg.sender == owner);
        require(!stopped);
        evidences[hash].accepted = true;
        emit EvidenceAccepted(evidences[hash].party, hash);
    }

    function viewEvidence(bytes32 hash) public view returns (bytes32, address, bool) {
        return (evidences[hash].hash, evidences[hash].party, evidences[hash].accepted);
    }

    function disputeEvidence(bytes32 hash) public {
        require(msg.sender == owner);
        require(evidences[hash].accepted == true);
        require(!stopped);
        emit EvidenceDisputed(evidences[hash].party, hash);
        delete evidences[hash];
        }

    function grantAccess(address party, bytes32 hash) public {
        require(msg.sender == owner);
        require(evidences[hash].accepted == true);
        require(!stopped);
        emit AccessGranted(party, hash);
        evidences[hash].party = party;
    }

    function emergencyStop() public {
        require(msg.sender == owner);
        stopped = true;
        emit EmergencyStop();
    }

    function resume() public {
        require(msg.sender == owner);
        stopped = false;
    }
}
