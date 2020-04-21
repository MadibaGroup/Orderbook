const DappToken = artifacts.require('DappToken');
const Orderbook = artifacts.require('Orderbook_V20');
var Orderbookaddress;
var tokenaddress;
var accounts;


contract('Orderbook', function(accounts) {
    it('should store the address of the orderbook into the var orderbookaddress', async() => {
        const OrderbookInstance = await Orderbook.deployed(); 
        Orderbookaddress = OrderbookInstance.address;
        console.log(OrderbookInstance.address);
    });




});






contract('DappToken', function(accounts) {
    
    //*******************Test 1*************************
    //  it('should deploy the smart contract properly', async() => {
    //      const DappTokenInstance = await DappToken.deployed(); 
    //      console.log(DappTokenInstance.address);
    //  });
    //*******************Test 2*************************
    // it('should return the balance of the accounts[0], async()=>{
    //     const DappTokenInstance = await DappToken.deployed();
    //     const result =  await DappTokenInstance.balanceOf(accounts[0]);
    //     console.log(result.toNumber());

    // });
    //*******************Test 3*************************
    //  it('should return the name of the token', async()=>{
    //      const DappTokenInstance = await DappToken.deployed();
    //      const name =  await DappTokenInstance.name();
    //      console.log(name);

    //  });
    //*******************Test 4*************************
        // var tokenInstance;
        // it('should return the name of the token', function(){
        //     return DappToken.deployed().then(function(instance){
        //         tokenInstance = instance;
        //         return tokenInstance.name();
        //     }).then(function(name){
        //         assert.equal(name, 'Dapp Token', 'The name is correct');
        //         return tokenInstance.symbol();
        //     }).then(function(symbol){
        //         assert.equal(symbol, 'DAPP', 'The symbol is correct');

        //     });
           
    
        // });
    //*******************Test 5*************************
        // it('should transfer 10 token to accounts[1]', async ()=> {
        //     const tokenInsatnce = await DappToken.deployed();
        //     await tokenInsatnce.transfer (accounts[1], 10, {from: accounts[0]});
        //     const result = await tokenInsatnce.balanceOf(accounts[1]);
        //     console.log(result.toNumber());



        // });
    //*******************Test 6*************************
    it('accounts[1] should transfer 10 token to ', async ()=> {
        const tokenInsatnce = await DappToken.deployed();
        tokenaddress = tokenInsatnce.address;
        await tokenInsatnce.approve (Orderbookaddress, 100, {from: accounts[0]});
        const result = await tokenInsatnce.allowance(accounts[0],Orderbookaddress);
        console.log(result.toNumber());



    });   

    

});
//*******************New test Block for the already deployed orderbook*************************
describe('Orderbook', function(accounts) {
    this.timeout(0);
    it('should deposit 100 tokens from accounst[0]', async() => {
        const OrderbookInstance = await Orderbook.deployed(); 

        accounts = await web3.eth.getAccounts();
       
        await OrderbookInstance.DepositToken (tokenaddress, 100, {from: accounts[0]});
        const result = await OrderbookInstance.TokenBalance(accounts[0], tokenaddress);
        console.log(result.toNumber());
    });
    //*******************Test 2*************************
    it('should OpenMarket on Dapp Token', async() => {
        const OrderbookInstance = await Orderbook.deployed(); 

        await OrderbookInstance.OpenMarket (tokenaddress);
        
    });
    
    //*******************Test 3*************************
     it('should submit 100 asks from accounst[0]', async() => {
         const OrderbookInstance = await Orderbook.deployed(); 
        
    //     //const state =  await OrderbookInstance.getState();
    //     //console.log(state.toString());
        
         accounts = await web3.eth.getAccounts();
         for(let j = 1; j < 101 ; j++) 
             await OrderbookInstance.submitAsk (j, 1, {from: accounts[0]});
         
         //await OrderbookInstance.submitAsk (10, 1, {from: accounts[0]});
         
    });
    //*******************Test 4*************************

    it('should return the token balance of accounts[0]', async() => {
        const OrderbookInstance = await Orderbook.deployed(); 
        
        accounts = await web3.eth.getAccounts();
        const result = await OrderbookInstance.TokenBalance(accounts[0], tokenaddress);
        console.log('The token balance of accounts[0] is:',result.toNumber());
        
    
    });
    //*******************Test 5*************************

    it('should deposit 100 Ether from accounts[1]', async() => {
        const OrderbookInstance = await Orderbook.deployed(); 
        

        accounts = await web3.eth.getAccounts();
        
        await OrderbookInstance.DepositEther ({from: accounts[1],  value: 100});
        const result = await OrderbookInstance.EtherBalance(accounts[1]);
        console.log('The Ether balance of accounts[1] is:', result.toNumber());
        
    
    });
    //*******************Test 6*************************
    it('should submit 100 Bids from accounst[1]', async() => {
        const OrderbookInstance = await Orderbook.deployed(); 
       
   //     //const state =  await OrderbookInstance.getState();
   //     //console.log(state.toString());
       
        accounts = await web3.eth.getAccounts();
        for(let j = 1; j < 101 ; j++) 
            await OrderbookInstance.submitBid (j, 1, {from: accounts[0]});
        
        //await OrderbookInstance.submitAsk (10, 1, {from: accounts[0]});
        
   });

});

//Notes and Tutorials:
//  1- if you write tests in two difefrenet contract blocks, they are independent and hence are talking to two completely different instances of your smart contract.
//  2- Inside our contract blocks, we define each test with an it statement.
//  3-