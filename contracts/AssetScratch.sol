pragma solidity ^0.5.0;

/*
* Implementation without using openzeppling.
*/

contract AssetScratch {

    string private _name;
    string private _symbol;

    struct Batch {
        string farmName;
        string pickingDate;
        string plantingDate;
        string farmLocation;
        int    weight;
        uint   smarCardID;
    }

    Batch[] batches;


    // Mapping from token ID to owner
    mapping (uint256 => address) private _tokenOwner;

    mapping (address => uint256) private _ownedTokensCount;

    mapping (address => mapping (uint256 => address)) private _pendingTransfers;

    // Events

    event Transfer(address from, address to, uint256 tokenId);
    event ProposeTransfer(address from, address to, uint256 tokenId);
    event RefuseTransfer(address from, address to, uint256 tokenId);


    constructor (string memory name, string memory symbol) public
    {
        _name = name;
        _symbol = symbol;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");

        return owner;
    }


    /*
        INTERNAL FUNCTIONS
     */

    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner);
    }

    function _transfer(address _from, address _to, uint256 _tokenId) internal
    {
        _ownedTokensCount[_to]++;

        _tokenOwner[_tokenId] = _to;

        if (_from != address(0x0)) {
            _ownedTokensCount[_from]--;
        }

        emit Transfer(_from, _to, _tokenId);
    }

    function _mint(address _to, uint256 _tokenId) internal
    {
        require(_to != address(0), "ERC721: mint to the zero address");
        require(!_exists(_tokenId), "ERC721: token already minted");

        _tokenOwner[_tokenId] = _to;
        _ownedTokensCount[_to]++;

        emit Transfer(address(0), _to, _tokenId);
    }


    function _createBatch(
        string memory _farmName,
        string memory _pickingDate,
        string memory _plantingDate,
        string memory _farmLocation,
        int    _weight,
        uint   _smartCardID,
        address _owner
    ) internal
      returns (uint) {

        Batch memory _Batch = Batch(
            _farmName,
            _pickingDate,
            _plantingDate,
            _farmLocation,
            _weight,
            _smartCardID
        );

        uint256 newBatchId = batches.push(_Batch) - 1;

        _mint(_owner, newBatchId);

        return newBatchId;
    }

    /*
     *    EXTERNAL FUNCTIONS
     */

    function createBatch(
        string calldata _farmName,
        string calldata _pickingDate,
        string calldata _plantingDate,
        string calldata _farmLocation,
        int    _weight,
        uint   _smartCardID
    ) external returns (uint) {

        address _creator = msg.sender;

        return _createBatch(_farmName, _pickingDate, _plantingDate, _farmLocation, _weight, _smartCardID, _creator);
    }


    function proposeTransfer(address from, address to, uint tokenId) external {
        require(_isApprovedOrOwner(msg.sender, tokenId));
        require(_pendingTransfers[from][tokenId] == address(0x0));

        _pendingTransfers[from][tokenId] = to;
        emit ProposeTransfer(from, to, tokenId);
    }

    function refuseTransfer(address from, address to, uint tokenId) external {
        require(to == msg.sender);
        require(_pendingTransfers[from][tokenId] == to);

        _pendingTransfers[from][tokenId] = address(0x0);

        emit RefuseTransfer(from, to, tokenId);
    }
}