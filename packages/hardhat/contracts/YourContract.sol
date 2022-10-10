pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

/**
 * @title MultiSig
 * @author neeraj27.eth
 * @dev We want to create an a multi-sig wallet to approve transactions based on required number of votes. This should also give ability to propose a transaction and revoke before execution.
 */

contract YourContract {
    /* ========== EVENTS ========== */
    /**
     * @notice Emitted when
     */
    event Deposit(address indexed sender, uint amount, uint balance);

    /**
     * @notice Emitted when
     */
    event Submit(uint indexed txId);

    /**
     * @notice Emitted when
     */
    event Approve(address indexed owner, uint indexed txId);

    /**
     * @notice Emitted when
     */
    event Revoke(address indexed owner, uint indexed txId);

    /**
     * @notice Emitted when
     */
    event ExecuteTransaction(
        address indexed owner,
        address payable to,
        uint value,
        bytes daat,
        uint256 nonce,
        bytes32 hash,
        bytes result
    );

    /**
     * @notice Emitted when
     */
    event Owner(address indexed owner, bool added);

    /* ========== GLOBAL VARIABLES ========== */

    struct Transactions {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public signaturesRequired;

    Transactions[] public transactions;
    mapping(uint => mapping(address => bool)) public approved;

    /* ========== MODIFIERS ========== */

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    /* ========== CONSTRUCTOR ========== */

    constructor(address[] memory _owners, uint256 _signaturesRequired) payable {
        require(_owners.length > 0, "owners required");
        require(
            _signaturesRequired > 0 && _signaturesRequired <= _owners.length,
            "invalid signatures"
        );
        for (uint256 i; i < _owners.length; i++) {
            address owner = owners[i];
            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner is not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        signaturesRequired = _signaturesRequired;
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    function submit(
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external onlyOwner {
        transactions.push(
            Transactions({to: _to, value: _value, data: _data, executed: false})
        );
        emit Submit(transactions.length - 1);
    }

    // to support receiving ETH by default
    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    fallback() external payable {}
}
