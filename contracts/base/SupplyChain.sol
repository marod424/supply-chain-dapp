// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

contract SupplyChain {
    address owner;
    uint  upc; // Universal Product Code (UPC)
    uint  sku; // Stock Keeping Unit (SKU)
    mapping (uint => Item) items; // map UPC to items
    mapping (uint => string[]) itemsHistory; // map UPC to array of TxHash (track journey through supply chain)

    enum State 
    { 
        Harvested, 
        Processed, 
        Packed, 
        ForSale, 
        Sold, 
        Shipped, 
        Received, 
        Purchased 
    }

    State constant defaultState = State.Harvested;

    struct Item {
        uint sku;
        uint upc;
        uint productID;
        string productNotes;
        uint productPrice;
        address ownerID;
        address originFarmerID;
        address distributorID;
        address retailerID;
        address consumerID;
        string originFarmName;
        string originFarmInformation;
        string originFarmLatitude;
        string originFarmLongitude;
        State itemState;
    }

    event Harvested(uint upc);
    event Processed(uint upc);
    event Packed(uint upc);
    event ForSale(uint upc);
    event Sold(uint upc);
    event Shipped(uint upc);
    event Received(uint upc);
    event Purchased(uint upc);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier verifyCaller (address _address) {
        require(msg.sender == _address); 
        _;
    }

    modifier paidEnough(uint _price) { 
        require(msg.value >= _price); 
        _;
    }

    modifier checkValue(uint _upc) {
        _;
        uint _price = items[_upc].productPrice;
        uint amountToReturn = msg.value - _price;
        address payable payableConsumer = payable(items[_upc].consumerID);
        payableConsumer.transfer(amountToReturn);
    }

    modifier harvested(uint _upc) {
        require(items[_upc].itemState == State.Harvested);
        _;
    }

    modifier processed(uint _upc) {
        require(items[_upc].itemState == State.Processed);
        _;
    }

    modifier packed(uint _upc) {
        require(items[_upc].itemState == State.Packed);
        _;
    }

    modifier forSale(uint _upc) {
        require(items[_upc].itemState == State.ForSale);
        _;
    }

    modifier sold(uint _upc) {
        require(items[_upc].itemState == State.Sold);
        _;
    }

    modifier shipped(uint _upc) {
        require(items[_upc].itemState == State.Shipped);
        _;
    }

    modifier received(uint _upc) {
        require(items[_upc].itemState == State.Received);
        _;
    }

    modifier purchased(uint _upc) {
        require(items[_upc].itemState == State.Purchased);
        _;
    }

    constructor() payable {
        owner = msg.sender;
        sku = 1;
        upc = 1;
    }

    function kill() public {
        if (msg.sender == owner) {
            selfdestruct(payable(owner));
        }
    }

    function harvestItem(
        uint _upc, 
        address _originFarmerID, 
        string memory _originFarmName, 
        string memory _originFarmInformation, 
        string memory _originFarmLatitude, 
        string memory _originFarmLongitude, 
        string memory _productNotes
    ) public {
    // Add the new item as part of Harvest

    sku = sku + 1;
    // Emit the appropriate event

    }

    // Define a function 'processtItem' that allows a farmer to mark an item 'Processed'
    function processItem(uint _upc) public 
    // Call modifier to check if upc has passed previous supply chain stage

    // Call modifier to verify caller of this function

    {
    // Update the appropriate fields

    // Emit the appropriate event

    }

    // Define a function 'packItem' that allows a farmer to mark an item 'Packed'
    function packItem(uint _upc) public 
    // Call modifier to check if upc has passed previous supply chain stage

    // Call modifier to verify caller of this function

    {
    // Update the appropriate fields

    // Emit the appropriate event

    }

    // Define a function 'sellItem' that allows a farmer to mark an item 'ForSale'
    function sellItem(uint _upc, uint _price) public 
    // Call modifier to check if upc has passed previous supply chain stage

    // Call modifier to verify caller of this function

    {
    // Update the appropriate fields

    // Emit the appropriate event

    }

    // Define a function 'buyItem' that allows the disributor to mark an item 'Sold'
    // Use the above defined modifiers to check if the item is available for sale, if the buyer has paid enough, 
    // and any excess ether sent is refunded back to the buyer
    function buyItem(uint _upc) public payable 
    // Call modifier to check if upc has passed previous supply chain stage

    // Call modifer to check if buyer has paid enough

    // Call modifer to send any excess ether back to buyer

    {

    // Update the appropriate fields - ownerID, distributorID, itemState

    // Transfer money to farmer

    // emit the appropriate event

    }

    // Define a function 'shipItem' that allows the distributor to mark an item 'Shipped'
    // Use the above modifers to check if the item is sold
    function shipItem(uint _upc) public 
    // Call modifier to check if upc has passed previous supply chain stage

    // Call modifier to verify caller of this function

    {
    // Update the appropriate fields

    // Emit the appropriate event

    }

    // Define a function 'receiveItem' that allows the retailer to mark an item 'Received'
    // Use the above modifiers to check if the item is shipped
    function receiveItem(uint _upc) public 
    // Call modifier to check if upc has passed previous supply chain stage

    // Access Control List enforced by calling Smart Contract / DApp
    {
    // Update the appropriate fields - ownerID, retailerID, itemState

    // Emit the appropriate event

    }

    // Define a function 'purchaseItem' that allows the consumer to mark an item 'Purchased'
    // Use the above modifiers to check if the item is received
    function purchaseItem(uint _upc) public 
    // Call modifier to check if upc has passed previous supply chain stage

    // Access Control List enforced by calling Smart Contract / DApp
    {
    // Update the appropriate fields - ownerID, consumerID, itemState

    // Emit the appropriate event

    }

    // Define a function 'fetchItemBufferOne' that fetches the data
    function fetchItemBufferOne(uint _upc) public view returns 
    (
        uint    itemSKU,
        uint    itemUPC,
        address ownerID,
        address originFarmerID,
        string memory originFarmName,
        string memory originFarmInformation,
        string memory originFarmLatitude,
        string memory originFarmLongitude
    ) 
    {
    // Assign values to the 8 parameters


    return 
    (
    itemSKU,
    itemUPC,
    ownerID,
    originFarmerID,
    originFarmName,
    originFarmInformation,
    originFarmLatitude,
    originFarmLongitude
    );
    }

    // Define a function 'fetchItemBufferTwo' that fetches the data
    function fetchItemBufferTwo(uint _upc) public view returns 
    (
    uint    itemSKU,
    uint    itemUPC,
    uint    productID,
    string memory productNotes,
    uint    productPrice,
    uint    itemState,
    address distributorID,
    address retailerID,
    address consumerID
    ) 
    {
    // Assign values to the 9 parameters


    return 
    (
    itemSKU,
    itemUPC,
    productID,
    productNotes,
    productPrice,
    itemState,
    distributorID,
    retailerID,
    consumerID
    );
    }
}
