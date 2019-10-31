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
    uint batch;

    function beforeAllCreateBatch() private {
        batch = avo.createBatch("Test farm before", "21-10-2019", "24-10-2019", "location", 10, 0);
    }
    // Create Batch
    function testCreateBatch() public {
       // Create batch
       uint newBatchId = avo.createBatch("test farm", "21", "21", "loc", 10, 1);
       Assert.equal(avo.balanceOf(expectedOwner), uint(1), "Batch creator should own 1 token");
       Assert.equal(avo.ownerOf(newBatchId), expectedOwner, "Batch creator should own the created token");
    }

    // Propose transfer
    function testPropose() public {
        avo.proposeTransfer(address(this), address(0x2), batch);
        Assert.equal(avo.getApproved(batch), address(0x2), "the approved address should be 2");
    }


    function testIfPossibleToCreateTest() public {
        avo.createTest("Maturity", "maturity", batch, true);
        uint256[] memory testIds = avo.getTestsForBatch(batch);
        Assert.equal(testIds.length, 1, "a test should be added");
    
    }

    function testIfItIsTestStatusIsCorrect() public {
        uint256[] memory testIds = avo.getTestsForBatch(batch);
        uint256 testId = testIds[0];
        bool status = avo.getSingleTestStatus(testId);
        Assert.equal(status, true, "get a single test and test if the status is true");
    }

    
}