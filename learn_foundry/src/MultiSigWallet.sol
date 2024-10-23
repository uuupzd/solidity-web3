// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

contract MultiSigWallet {
    // Multiple visa holders
    address[] public owners;
    // Signature threshold
    uint256 public signatureThreshold;

    struct TransactionProposal {
        address destination;
        uint256 value;
        bool executed;
        uint256 approvalCount;
        mapping(address => bool) approvals;
    }

    uint256 public proposalCount;
    mapping(uint256 => TransactionProposal) public proposals;

    event ProposalSubmitted(
        uint256 indexed proposalId,
        address indexed deposination,
        uint256 value
    );
    event ProposalApproved(
        uint256 indexed proposalId,
        address indexed approved
    );
    event ProposalExecuted(uint256 indexed proposalId);

    modifier onlyOwners() {
        require(isOwner(msg.sender), "Not an owner");
        _;
    }

    modifier proposalExists(uint proposalId) {
        require(proposalId < proposalCount, "Proposal does not exist");
        _;
    }

    modifier notExecuted(uint proposalId) {
        require(!proposals[proposalId].executed, "Proposal already executed");
        _;
    }

    modifier notApproved(uint proposalId) {
        require(!proposals[proposalId].approvals[msg.sender], "Already approved");
        _;
    }

    constructor(address[] memory _owners) {
        require(_owners.length > 0, "Owners require");
        owners = _owners;
        signatureThreshold = (_owners.length / 2) + 1;
    }

    function isOwner(address addr) public view returns (bool) {
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == addr) {
                return true;
            }
        }
        return false;
    }

    //创建提案
    function proposal(address destination, uint256 value) public onlyOwners {
        TransactionProposal storage newProposal = proposals[proposalCount++];
        newProposal.destination = destination;
        newProposal.value = value;
        newProposal.executed = false;
        newProposal.approvalCount = 0;
        newProposal.approvals[msg.sender] = true; //Automatic approval by the sponsor

        newProposal.approvalCount++;

        emit ProposalSubmitted(proposalCount - 1, destination, value);
        emit ProposalApproved(proposalCount - 1, msg.sender);
    }

    //确认提案
    function approve(uint256 proposalId)
        public
        onlyOwners
        proposalExists(proposalId)
        notExecuted(proposalId)
        notApproved(proposalId)
    {
        TransactionProposal storage propose = proposals[proposalId];
        propose.approvals[msg.sender] = true;
        propose.approvalCount++;
        emit ProposalApproved(proposalId, msg.sender);

        if (propose.approvalCount >= signatureThreshold) {
            execute(proposalId);
        }
    }

    //达到提案条件自动执行提案
    function execute(uint256 proposalId)
        public
        proposalExists(proposalId)
        notExecuted(proposalId)
    {
        TransactionProposal storage propose = proposals[proposalId];
        require(
            propose.approvalCount >= signatureThreshold,
            "Not enough approvals"
        );
        propose.executed = true;
        (bool successs, ) = propose.destination.call{value: propose.value}("");
        require(successs, "Transaction failed");

        emit ProposalExecuted(proposalId);
    }

    receive() external payable {}
}
