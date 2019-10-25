pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Asset.sol";

contract TestAsset {
    Asset avo = Asset(DeployedAddresses.Asset());

    address expectedOwner = address(this);

    function testSimple() public {
        Assert.equal(uint(0), uint(0), "should pass");
    }

    // Create Batch
    function testCreateBatch() public {
       // Create batch
       uint newBatchId = avo.createBatch("test farm", "21", "21", "loc", 10, 0);
       Assert.equal(avo.balanceOf(expectedOwner), uint(1), "Batch creator should own 1 token");
       Assert.equal(avo.ownerOf(newBatchId), expectedOwner, "Batch creator should own the created token");
    }

    // Propose transfer
    function testTransfer() public {

    }

    // Reject transfer


    // Accept transfer

    // something with creating and verifing

    
}