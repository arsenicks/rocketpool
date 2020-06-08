import { RocketNodeManager } from '../_utils/artifacts';


// Register a node
export async function registerNode(timezoneLocation, txOptions) {

    // Load contracts
    const rocketNodeManager = await RocketNodeManager.deployed();

    // Get node details
    function getDetails(nodeAddress) {
        return Promise.all([
            rocketNodeManager.getNodeExists.call(nodeAddress),
            rocketNodeManager.getNodeTrusted.call(nodeAddress),
            rocketNodeManager.getNodeContract.call(nodeAddress),
            rocketNodeManager.getNodeTimezoneLocation.call(nodeAddress),
        ]).then(
            ([exists, trusted, contractAddress, timezoneLocation]) =>
            ({exists, trusted, contractAddress, timezoneLocation})
        );
    }

    // Get initial node count
    let nodeCount1 = await rocketNodeManager.getNodeCount.call();

    // Register
    await rocketNodeManager.registerNode(timezoneLocation, txOptions);

    // Get updated node count & node details
    let nodeCount2 = await rocketNodeManager.getNodeCount.call();
    let lastNodeAddress = await rocketNodeManager.getNodeAt.call(nodeCount2.sub(web3.utils.toBN(1)));
    let details = await getDetails(txOptions.from);

    // Check details
    assert(nodeCount2.eq(nodeCount1.add(web3.utils.toBN(1))), 'Incorrect updated node count');
    assert.equal(lastNodeAddress, txOptions.from, 'Incorrect updated node index');
    assert.isTrue(details.exists, 'Incorrect node exists flag');
    assert.isFalse(details.trusted, 'Incorrect node trusted flag');
    assert.notEqual(details.contractAddress, '0x0000000000000000000000000000000000000000', 'Incorrect node contract address');
    assert.equal(details.timezoneLocation, timezoneLocation, 'Incorrect node timezone location');

}
