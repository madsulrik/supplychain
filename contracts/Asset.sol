pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";

contract Asset is ERC721Full {

    struct Batch {
        string farmName;
        string pickingDate;
        string plantingDate;
        string farmLocation;
        int    weight;
        uint   smarCardID;
    }

    struct Test {
        string name;
        string ttype;
        address verificator;
        uint256 tokenId;
        bool accepted;
        // other metadata
    }

    Batch[] batches;
    Test[] tests;

    constructor(string memory name, string memory symbol) ERC721Full(name, symbol) public {

    }

    mapping (address => mapping (uint256 => address)) private _pendingTransfers;

    mapping (uint256 => uint256[]) private _batchTests;

    event ProposeTransfer(address from, address to, uint256 tokenId);
    event RefuseTransfer(address from, address to, uint256 tokenId);
    event TestCreation(address creator, uint256 testId, uint256 tokenId);

    /* 
    * FUNCTIONS
    */

    function createBatch(
        string memory _farmName,
        string memory _pickingDate,
        string memory _plantingDate,
        string memory _farmLocation,
        int    _weight,
        uint   _smartCardID
    ) public
      returns (uint) {

        address _creator = msg.sender;

        Batch memory _Batch = Batch(
            _farmName,
            _pickingDate,
            _plantingDate,
            _farmLocation,
            _weight,
            _smartCardID
        );

        uint256 newBatchId = batches.push(_Batch) - 1;

        _mint(_creator, newBatchId);

        return newBatchId;
    }

    function proposeTransfer(address from, address to, uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender);
        require(_pendingTransfers[from][tokenId] == address(0x0));

        _pendingTransfers[from][tokenId] = to;

        approve(to, tokenId);

        emit ProposeTransfer(from, to, tokenId);
    }

    function refuseTransfer(address from, address to, uint256 tokenId) external {
        require(to == msg.sender);
        require(_pendingTransfers[from][tokenId] == to);

        _pendingTransfers[from][tokenId] = address(0x0);
        approve(address(0x0), tokenId);

        emit RefuseTransfer(from, to, tokenId);
    }

    function acceptTransfer(address from, address to, uint256 tokenId) external {
        require(_isApprovedOrOwner(msg.sender, tokenId));
        require(to == msg.sender);
        require(_pendingTransfers[from][tokenId] == to);


        _pendingTransfers[from][tokenId] = address(0x0);

        transferFrom(from, to, tokenId);
    }


    function createTest(
        string calldata name,
        string calldata ttype,
        uint256 tokenId,
        bool accepted
    ) external {
        require(_isApprovedOrOwner(msg.sender, tokenId));

        Test memory _test = Test(name, ttype, msg.sender, tokenId, accepted);

        uint256 newTestId = tests.push(_test) - 1;

        _batchTests[tokenId].push(newTestId);

        emit TestCreation(msg.sender, newTestId, tokenId);
    }

}

