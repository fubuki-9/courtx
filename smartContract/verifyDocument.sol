pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/ownership/Ownable.sol";

contract DocumentVerification is Ownable {
    using SafeMath for uint256;

    struct Document {
        bytes32 hash;
        uint256 timestamp;
        address owner;
        bytes32 proof;
    }

    mapping(bytes32 => Document) documents;

    event DocumentAdded(bytes32 indexed hash, address indexed owner, uint256 timestamp);
    event DocumentVerified(bytes32 indexed hash, address indexed owner);

    function addDocument(bytes32 hash, bytes32 proof) public {
        require(documents[hash].hash == bytes32(0));
        require(verifyProof(proof));
        documents[hash] = Document(hash, now, msg.sender, proof);
        emit DocumentAdded(hash, msg.sender, now);
    }

    function verifyDocument(bytes32 hash) public {
        require(msg.sender == owner);
        require(documents[hash].hash != bytes32(0));
        require(verifyProof(documents[hash].proof));
        emit DocumentVerified(hash, documents[hash].owner);
    }

    function verifyProof(bytes32 proof) private view returns (bool) {
        // This function should contain the logic for verifying the zero-knowledge proof
        // using a specific zk-SNARK library or tool, such as libsnark or zokrates
        // Example:
        // return zokrates.verify(proof);
    }
}
