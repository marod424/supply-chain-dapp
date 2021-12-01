// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "../core/Ownable.sol";
import "../acl/ConsumerRole.sol";
import "../acl/DistributorRole.sol";
import "../acl/ProducerRole.sol";
import "../acl/RetailerRole.sol";

contract SupplyChain is 
    Ownable, 
    ConsumerRole, 
    DistributorRole, 
    ProducerRole,
    RetailerRole
{
    uint  upc; // Universal Product Code (UPC)
    uint  sku; // Stock Keeping Unit (SKU)
    mapping (uint => Item) items; // map UPC to items
    mapping (uint => string[]) itemsHistory; // map UPC to array of TxHash

    enum State 
    { 
        Produced, 
        Processed, 
        Packed, 
        ForSale, 
        Sold, 
        Shipped, 
        Received, 
        Purchased 
    }

    State constant defaultState = State.Produced;

    struct Item {
        uint sku;
        uint upc;
        uint productID;
        string productNotes;
        uint productPrice;
        address ownerID;
        address producerID;
        string producerName;
        string producerInformation;
        string producerLatitude;
        string producerLongitude;
        address distributorID;
        address retailerID;
        address consumerID;
        State itemState;
    }

    event Produced(uint upc);
    event Processed(uint upc);
    event Packed(uint upc);
    event ForSale(uint upc);
    event Sold(uint upc);
    event Shipped(uint upc);
    event Received(uint upc);
    event Purchased(uint upc);

    modifier verifyCaller(address _address) {
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

    modifier produced(uint _upc) {
        require(items[_upc].itemState == State.Produced);
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
        sku = 1;
        upc = 1;
    }

    function kill() public onlyOwner {
        selfdestruct(payable(owner()));
    }

    function produceItem(
        uint _upc, 
        address _producerID, 
        string memory _producerName, 
        string memory _producerInformation, 
        string memory _producerLatitude, 
        string memory _producerLongitude, 
        string memory _productNotes
    ) public onlyProducer {
        items[_upc] = Item({
            sku: sku,
            upc: _upc,
            productID: sku + _upc,
            productNotes: _productNotes,
            productPrice: 0,
            ownerID: _producerID,
            producerID: _producerID,
            producerName: _producerName,
            producerInformation: _producerInformation,
            producerLatitude: _producerLatitude,
            producerLongitude: _producerLongitude,
            distributorID: address(0),
            retailerID: address(0),
            consumerID: address(0),
            itemState: defaultState
        });

        sku = sku + 1;
        emit Produced(_upc);
    }

    function processItem(uint _upc) public produced(_upc) onlyProducer {
        items[_upc].itemState = State.Processed;
        emit Processed(_upc);
    }

    function packItem(uint _upc) public processed(_upc) onlyProducer {
        items[_upc].itemState = State.Packed;
        emit Packed(_upc);
    }

    function sellItem(uint _upc, uint _price) public packed(_upc) onlyProducer {
        items[_upc].productPrice = _price;
        items[_upc].itemState = State.ForSale;
        emit ForSale(_upc);
    }

    function buyItem(uint _upc) 
        public 
        payable 
        forSale(_upc)
        paidEnough(msg.value)
        checkValue(_upc)
        onlyDistributor
    {
        items[_upc].ownerID = msg.sender;
        items[_upc].distributorID = msg.sender;
        items[_upc].itemState = State.Sold;

        payable(items[_upc].producerID).transfer(items[_upc].productPrice);

        emit Sold(_upc);
    }

    function shipItem(uint _upc) public sold(_upc) onlyDistributor {
        items[_upc].itemState = State.Shipped;
        emit Shipped(_upc);
    }

    function receiveItem(uint _upc) public shipped(_upc) onlyRetailer {
        items[_upc].ownerID = msg.sender;
        items[_upc].retailerID = msg.sender;
        items[_upc].itemState = State.Received;
        emit Received(_upc);
    }

    function purchaseItem(uint _upc) public received(_upc) onlyConsumer {
        items[_upc].ownerID = msg.sender;
        items[_upc].consumerID = msg.sender;
        items[_upc].itemState = State.Purchased;
        emit Purchased(_upc);
    }

    function fetchItemBufferOne(uint _upc) 
        public 
        view 
        returns (
            uint itemSKU,
            uint itemUPC,
            address ownerID,
            address producerID,
            string memory producerName,
            string memory producerInformation,
            string memory producerLatitude,
            string memory producerLongitude
        ) 
    {
        Item memory item = items[_upc];
        return (
            item.sku,
            item.upc,
            item.ownerID,
            item.producerID,
            item.producerName,
            item.producerInformation,
            item.producerLatitude,
            item.producerLongitude
        );
    }

    function fetchItemBufferTwo(uint _upc) 
        public 
        view 
        returns (
            uint itemSKU,
            uint itemUPC,
            uint productID,
            string memory productNotes,
            uint productPrice,
            uint itemState,
            address distributorID,
            address retailerID,
            address consumerID
        ) 
    {
        Item memory item = items[_upc];
        return (
            item.sku,
            item.upc,
            item.productID,
            item.productNotes,
            item.productPrice,
            uint(item.itemState),
            item.distributorID,
            item.retailerID,
            item.consumerID
        );
    }
}
