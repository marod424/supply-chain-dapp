const SupplyChain = artifacts.require('SupplyChain');

contract('SupplyChain', function(accounts) {
    describe("Testing Supply Chain smart contract", async () => {
        let supplyChain;
        let eventEmitted;
        let sku = 1;
        let upc = 1;
        let productID = sku + upc;
        
        const producerID = accounts[1];
        const producerName = "John Doe";
        const producerInformation = "Yarray Valley";
        const producerLatitude = "-38.239770";
        const producerLongitude = "144.341490";
        const productNotes = "Humane, Natural, and Organic";
        const productPrice = web3.utils.toWei('1', "ether");
        const distributorID = accounts[2];
        const retailerID = accounts[3];
        const consumerID = accounts[4];
    
        console.log("truffle accounts used here...");
        console.log("Contract Owner: accounts[0] ", accounts[0]);
        console.log("Producer: accounts[1] ", accounts[1]);
        console.log("Distributor: accounts[2] ", accounts[2]);
        console.log("Retailer: accounts[3] ", accounts[3]);
        console.log("Consumer: accounts[4] ", accounts[4]);
        
        before(async () => {
            supplyChain = await SupplyChain.deployed();

            await supplyChain.addProducer(producerID);
            await supplyChain.addDistributor(distributorID);
            await supplyChain.addRetailer(retailerID);
            await supplyChain.addConsumer(consumerID);
        });

        after(async () => {
            await supplyChain.renounceProducer({from: producerID});
            await supplyChain.renounceDistributor({from: distributorID});
            await supplyChain.renounceRetailer({from: retailerID});
            await supplyChain.renounceConsumer({from: consumerID});
        });

        beforeEach(() => {
            eventEmitted = false;
        });

        it("function produceItem() should allow a producer to produce a product", async() => {
            supplyChain.Produced(null, () => eventEmitted = true);
            
            await supplyChain.produceItem(
                upc, 
                producerID, 
                producerName, 
                producerInformation, 
                producerLatitude, 
                producerLongitude, 
                productNotes,
                {from: producerID}
            );
    
            const resultBufferOne = await supplyChain.fetchItemBufferOne.call(upc);
            const resultBufferTwo = await supplyChain.fetchItemBufferTwo.call(upc);
    
            assert.equal(resultBufferOne[0], sku, 'Error: Invalid item SKU');
            assert.equal(resultBufferOne[1], upc, 'Error: Invalid item UPC');
            assert.equal(resultBufferOne[2], producerID, 'Error: Missing or Invalid ownerID');
            assert.equal(resultBufferOne[3], producerID, 'Error: Missing or Invalid producerID');
            assert.equal(resultBufferOne[4], producerName, 'Error: Missing or Invalid producerName');
            assert.equal(resultBufferOne[5], producerInformation, 'Error: Missing or Invalid producerInformation');
            assert.equal(resultBufferOne[6], producerLatitude, 'Error: Missing or Invalid producerLatitude');
            assert.equal(resultBufferOne[7], producerLongitude, 'Error: Missing or Invalid producerLongitude');
            assert.equal(resultBufferTwo[5], 0, 'Error: Invalid item State');
            assert.equal(eventEmitted, true, 'Invalid event emitted');      
        });
    
        it("function processItem() should allow a producer to process a product", async() => {
            supplyChain.Processed(null, () => eventEmitted = true);

            await supplyChain.processItem(upc, {from: producerID});
    
            const resultBufferTwo = await supplyChain.fetchItemBufferTwo.call(upc);

            assert.equal(resultBufferTwo[5], 1, 'Error: Invalid item State');
            assert.equal(eventEmitted, true, 'Invalid event emitted');   
        });   
    
        it("function packItem() should allow a producer to pack a product", async() => {
            supplyChain.Packed(null, () => eventEmitted = true);

            await supplyChain.packItem(upc, {from: producerID});
    
            const resultBufferTwo = await supplyChain.fetchItemBufferTwo.call(upc);

            assert.equal(resultBufferTwo[5], 2, 'Error: Invalid item State');
            assert.equal(eventEmitted, true, 'Invalid event emitted');   
        });
    
        it("function sellItem() should allow a producer to sell a product", async() => {
            supplyChain.ForSale(null, () => eventEmitted = true);

            await supplyChain.sellItem(upc, productPrice, {from: producerID});
    
            const resultBufferTwo = await supplyChain.fetchItemBufferTwo.call(upc);

            assert.equal(resultBufferTwo[4], productPrice, 'Error: Missing or Invalid productPrice');
            assert.equal(resultBufferTwo[5], 3, 'Error: Invalid item State');
            assert.equal(eventEmitted, true, 'Invalid event emitted');   
        });
    
        it("function buyItem() should allow a distributor to buy a product", async() => {
            supplyChain.Sold(null, () => eventEmitted = true);

            const producerBalanceBefore = await web3.eth.getBalance(producerID);
            await supplyChain.buyItem(upc, {from: distributorID, value: productPrice});
            const producerBalanceAfter = await web3.eth.getBalance(producerID);

            const resultBufferOne = await supplyChain.fetchItemBufferOne.call(upc);
            const resultBufferTwo = await supplyChain.fetchItemBufferTwo.call(upc);

            assert.equal(resultBufferOne[2], distributorID, 'Error: Missing or Invalid ownerID');
            assert.equal(resultBufferTwo[6], distributorID, 'Error: Missing or Invalid distributorID');
            assert.equal(resultBufferTwo[5], 4, 'Error: Invalid item State');
            assert.equal(eventEmitted, true, 'Invalid event emitted');
            assert.equal(producerBalanceAfter - producerBalanceBefore, productPrice, 'Error: Invalid transfer; producer was not paid');
        });

        it("function shipItem() should allow a distributor to ship a product", async() => {
            supplyChain.Shipped(null, () => eventEmitted = true);

            await supplyChain.shipItem(upc, {from: distributorID});
    
            const resultBufferTwo = await supplyChain.fetchItemBufferTwo.call(upc);

            assert.equal(resultBufferTwo[5], 5, 'Error: Invalid item State');
            assert.equal(eventEmitted, true, 'Invalid event emitted');   
        });
    
        it("function receiveItem() should allow a retailer to mark a product received", async() => {
            supplyChain.Received(null, () => eventEmitted = true);

            await supplyChain.receiveItem(upc, {from: retailerID});
    
            const resultBufferOne = await supplyChain.fetchItemBufferOne.call(upc);
            const resultBufferTwo = await supplyChain.fetchItemBufferTwo.call(upc);

            assert.equal(resultBufferOne[2], retailerID, 'Error: Missing or Invalid ownerID');
            assert.equal(resultBufferTwo[7], retailerID, 'Error: Missing or Invalid retailerID');
            assert.equal(resultBufferTwo[5], 6, 'Error: Invalid item State');
            assert.equal(eventEmitted, true, 'Invalid event emitted');   
        });
    
        it("function purchaseItem() should allow a consumer to purchase a product", async() => {
            supplyChain.Purchased(null, () => eventEmitted = true);

            await supplyChain.purchaseItem(upc, {from: consumerID});
    
            const resultBufferOne = await supplyChain.fetchItemBufferOne.call(upc);
            const resultBufferTwo = await supplyChain.fetchItemBufferTwo.call(upc);

            assert.equal(resultBufferOne[2], consumerID, 'Error: Missing or Invalid ownerID');
            assert.equal(resultBufferTwo[8], consumerID, 'Error: Missing or Invalid consumerID');
            assert.equal(resultBufferTwo[5], 7, 'Error: Invalid item State');
            assert.equal(eventEmitted, true, 'Invalid event emitted');  
        }); 
    
        it("function fetchItemBufferOne() should allow anyone to fetch item details from blockchain", async() => {
            const resultBufferOne = await supplyChain.fetchItemBufferOne.call(upc);

            assert.equal(resultBufferOne[0], sku, 'Error: Invalid item SKU');
            assert.equal(resultBufferOne[1], upc, 'Error: Invalid item UPC');
            assert.equal(resultBufferOne[2], consumerID, 'Error: Missing or Invalid ownerID');
            assert.equal(resultBufferOne[3], producerID, 'Error: Missing or Invalid producerID');
            assert.equal(resultBufferOne[4], producerName, 'Error: Missing or Invalid producerName');
            assert.equal(resultBufferOne[5], producerInformation, 'Error: Missing or Invalid producerInformation');
            assert.equal(resultBufferOne[6], producerLatitude, 'Error: Missing or Invalid producerLatitude');
            assert.equal(resultBufferOne[7], producerLongitude, 'Error: Missing or Invalid producerLongitude');
        });
    
        it("function fetchItemBufferTwo() should allow anyone to fetch item details from blockchain", async() => {
            const resultBufferTwo = await supplyChain.fetchItemBufferTwo.call(upc);

            assert.equal(resultBufferTwo[0], sku, 'Error: Invalid item SKU');
            assert.equal(resultBufferTwo[1], upc, 'Error: Invalid item UPC');
            assert.equal(resultBufferTwo[2], productID, 'Error: Missing or Invalid productID');
            assert.equal(resultBufferTwo[3], productNotes, 'Error: Missing or Invalid productNotes');
            assert.equal(resultBufferTwo[4], productPrice, 'Error: Missing or Invalid productPrice');
            assert.equal(resultBufferTwo[5], 7, 'Error: Invalid item State');
            assert.equal(resultBufferTwo[6], distributorID, 'Error: Missing or Invalid distributorID');
            assert.equal(resultBufferTwo[7], retailerID, 'Error: Missing or Invalid retailerID');
            assert.equal(resultBufferTwo[8], consumerID, 'Error: Missing or Invalid consumerID');
        });
    });
});