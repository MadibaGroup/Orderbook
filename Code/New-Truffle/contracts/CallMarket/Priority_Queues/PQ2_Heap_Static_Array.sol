pragma solidity >=0.4.22;
pragma experimental ABIEncoderV2;

//Heap with static array wrapped in a priority queue
//Maximum number of order the Match function can handle:

contract PQ2_Heap_Static_Array{
    
    constructor (uint256 _MAXORDERS) public
    {
        MAXORDERS = _MAXORDERS;
    }

//Every order has some attributes:
    struct OrderStruct 
    {
        address Sender;
        uint256 Price;
        uint256 Volume;     //The volume is 1 for now
        bool Exists;
        uint256 AuxPrice;   //This is not the real price of the order, it's the contcantenation of the real price and the counter which helps to sort the heap wehen there are ties

        
    }
    uint256 public MAXORDERS;
    OrderStruct[80] BuyList;  //The array that contains Bid OrderStructs (descending (decremental)), we always want the highest bid (maxheap)
    OrderStruct[80] SellList; //The array that contains Ask OrderStructs (ascending (incremental)), we always want the lowest ask (minheap)
    uint256 public SellIndex;
    uint256 public BuyIndex;

//*****************************************************************//
//*******************  maxheap Functions (BuyList) ****************//
//*****************************************************************//

//*******************  InsertBid() ***************************//
    //the new item will be added to the end of the array list (a buy order is submitted)
    //then heapified up with a call to heapifyUp method
    function InsertBid (address _sender, uint256 _price, uint256 _volume, uint256 _auxprice) public returns (bool)
    {
        OrderStruct memory neworder = OrderStruct(_sender, _price , _volume, true, _auxprice);

        if (BuyList[0].Exists == false)
        {
            BuyList[0] = neworder; 
        }
       else{
            BuyIndex ++;
            BuyList[BuyIndex] = neworder;
            maxheap_heapifyUp ();
        }    
    }    
//*******************  maxheap_heapifyUp () ***************************//
    //this function is called everytime we insert a new element to the end of the array (aka a new Buy order is submitted) and
    //now the heap has to be sorted again
    function maxheap_heapifyUp () internal 
    returns (bool) {

        uint256 k = BuyIndex;                   //k is set to be the last entry of the array (also heap) which is the element that's just added and has to be moved up
        while (k > 0){                                  //while we havent reached to the top of the heap
            uint256 p = (k-1)/2;                           //we need to compute the parent of this last element which is p = (k-1)/2
            if (BuyList[k].AuxPrice > BuyList[p].AuxPrice) //if the element is greater than its parent
            {   
                OrderStruct memory temp = BuyList[k];    //swap the element at index k with its parent
                BuyList[k] = BuyList[p];
                BuyList[p] = temp;
                k = p;                                  //k moves up one level
            }
            else {break;}                               //if not the break statement exits the loop (it continues until no element index k is not greater than its parent)
        }
    
        return true;
    }

//******************** BuyListMaxDelete() function ********************//    
    //the highest priority item will be removed from the list and is returned by the function
    //then the heap is reordered uising the heapifyDown method
    function BuyListMaxDelete() public returns (uint256, address) 
    {   
        require (BuyList[0].Exists != false, 'BuyList is empty!');   //the delete function throws exception if the list is empty
        uint256 _price =  BuyList[0].Price;
        address _sender =  BuyList[0].Sender;
        
        if (BuyIndex == 0) 
        { 
            delete BuyList[0];
            return(_price,_sender);

        }                           
        if (BuyIndex == 1)
        {                                      //if the heap has two items
                                    
            BuyList[0] = BuyList[1]; //the first element of the heap is removed 
            delete BuyList[1];
            BuyIndex --;
            return(_price,_sender);
            
       
        }
        //if neither of these conditions are true, then there are at least 2 items in the heap and deletion proceeds
        BuyList[0] = BuyList[BuyIndex]; //the last elementof the heap is removed and written into the first position
        delete BuyList[BuyIndex];
        maxheap_heapifyDown(); //now the siftdown is called
        BuyIndex--;
        return(_price,_sender);
    }

//*******************  maxheap_heapifyDown () ***************************//
    //when we want to remove an element from the heap we remove the root of the heap and add the last item
    //to the root and reorder the heap again
    function maxheap_heapifyDown () internal 
 
    returns (bool)
    {
        uint256 k =0;
        uint256 leftchild = 2*k + 1;
        while (leftchild < BuyIndex )
        {                                   //as long as the left child is within the array that heap is stored in
            uint256 max = leftchild;
            uint256 rightchild = leftchild + 1;                                     //rightchild = 2k+2

            if (rightchild < BuyIndex )                                       //if there is a rightchild
            {
                if (BuyList[rightchild].AuxPrice > BuyList[leftchild].AuxPrice)    //then the right child and left child are compared
                {
                    max++;                                                       //now max is set to rightchild, otherwise max remains to be the leftchild
                }
            }

        if (BuyList[k].AuxPrice < BuyList[max].AuxPrice)                        //compares the k item with the max item and if k is smaller than its greatest children they are swapped
        {
            
            OrderStruct memory temp = BuyList[k];    //swap the element at index k with its parent
            BuyList[k] = BuyList[max];
            BuyList[max] = temp;
            k = max;                                                         //k is set to max
            leftchild =2*k + 1;                                              //l is recompuetd in preparation for the next iteration
        }
        else{                                                               //if the k item is not smaller than the max item, heapifyDown should stop
            break;
            }
        }
        return true;
    }
    
//****************   BuyListMaxPrice()  *********************//
    //BuyListMaxPrice function returns the price of the highest priority element (The highest bid)
    function BuyListMaxPrice() public  returns (uint256){
        
        require (BuyList[0].Exists == true, 'BuyList is empty!'); //throws exception if the maxheap (BuyList) is empty
        return (BuyList[0].Price);
        
    }
//****************   BuyListMaxSender()  *********************//
    //BuyListMaxSender function returns the sender of the highest priority element (The highest bid)
    function BuyListMaxSender() public  returns (address){
        
        require (BuyList[0].Exists == true, 'BuyList is empty!'); //throws exception if the maxheap (BuyList) is empty
        return (BuyList[0].Sender);
        
    }
//****************   BuyListisEmpty()  *********************//
    //checks if the Buylist is empty or not 
    function BuyListisEmpty() public returns (bool){
        
        if (BuyList[BuyIndex].Exists == false)
        {
            return true;

        }
        else
        {
            return false;
        }
        
    }
//*****************************************************************//
//*******************  minheap Functions (SellList) ****************//
//*****************************************************************//

//*******************  minheap_insert () ***************************//
    //the new item will be added to the end of the array list (a sell order is submitted)
    //then heapified up with a call to heapifyUp method
    function InsertAsk (address _sender, uint256 _price, uint256 _volume, uint256 _auxprice) public  returns (bool)
    {
        OrderStruct memory neworder = OrderStruct(_sender, _price , _volume, true, _auxprice); 
        
        if (SellList[0].Exists == false)
        {
           SellList[0] = neworder;
           
        }
        else
        {
            SellIndex ++;
            SellList[SellIndex] = neworder;
            minheap_heapifyUp();
        }
    
        return true;
    }    
//*******************  minheap_heapifyUp () ***************************//
    //this function is called everytime we insert a new element to the end of the array (aka a new sell order is submitted) and
    //now the heap has to be sorted again
    function minheap_heapifyUp () internal 
    //CheckAuctionStage ()
    returns (bool) {

        uint256 k = SellIndex ; //k is set to be the last entry of the array(also heap) which is the element that's just added and has to be moved up
        while (k > 0){                                      //while we havent reached to the top of the heap
            uint256 p = (k-1)/2;                            //we need to compute the parent of this last element which is p = (k-1)/2
            if (SellList[k].AuxPrice < SellList[p].AuxPrice) //if the element is greater than its parent
            { 
            
                OrderStruct memory temp = SellList[k];    //swap the element at index k with its parent
                SellList[k] = SellList[p];
                SellList[p] = temp;
                
                k = p; //k moves up one level
            }
            else {break;} //if not the break statement exits the loop (it continues until no element index k is not greater than its parent)
        }
        
        return true;
    }    
//****************   SellListMaxPrice()  *********************//
    //SellListMaxPrice function returns the price of the highest priority element (The Lowest ask)
    function SellListMaxPrice() public  returns (uint256){

        require(SellList[0].Exists == true,'SellList is empty!'); //throws exception if the minheap (SellList) is empty
        return (SellList[0].Price);
    }
//****************   SellListMaxSender()  *********************//
    //SellListMaxSender function returns the address of the highest priority element (The Lowest ask)
    function SellListMaxSender() public  returns (address){

        require(SellList[0].Exists == true,'SellList is empty!'); //throws exception if the minheap (SellList) is empty
        return (SellList[0].Sender);
    }
//****************   SellListisEmpty()  *********************//
    //checks if the SellList is empty or not 
    function SellListisEmpty() public returns (bool){
        
        if (SellList[SellIndex].Exists == false)
        {
            return true;

        }
        else
        {
            return false;
        }
        
    }
//*******************  SellListMaxDelete () ***************************//
    //the highest priority item (the lowest ask) will be removed from the list and is returned by the function
    //then the heap is reordered uising the heapifyDown method
    function SellListMaxDelete() public returns (uint256, address)
    {
        require(SellList[0].Exists != false,'SellList is empty!');            //the delete function throws exception if the list is empty
        uint256 _price =  SellList[0].Price;
        address _sender =  SellList[0].Sender;
        
        if (SellIndex == 0) 
        {
            delete SellList[0]; 
            return (_price,_sender);
        }
            
        
        if (SellIndex == 1) {                               // if the heap has only one item
   
            BuyList[0] = BuyList[1];
            delete SellList[1];                                   //the only element of the heap is removed and returned  
            SellIndex --;
            return (_price,_sender);
        }

        //if neither of these conditions are true, then there are at least 2 items in the heap and deletion proceeds
      
       
        SellList[0] = SellList[SellIndex];                      //the last elementof the heap is removed and written into the first position
        delete SellList[SellIndex]; 
        minheap_heapifyDown();                           //now the heapifyDown is called to restore the ordering of the heap 
        SellIndex--;
        return (_price,_sender);
    }
//*******************  minheap_heapifyDown () ***************************//
    //when we want to remove an element from the heap we remove the root of the heap and add the last item
    //to the root and reorder the heap again
    function minheap_heapifyDown () internal 
    //CheckAuctionStage ()
    returns (bool) {
        uint256 k =0;
        uint256 leftchild = 2*k + 1;
        while (leftchild < SellIndex ){               //as long as the left child is within the array that heap is stored in
            uint256 min = leftchild;
            uint256 rightchild = leftchild + 1;              //rightchild = 2k+2

            if (rightchild < SellIndex )                //if there is a rightchild, then the right child and left child are compared
            {
                if (SellList[rightchild].AuxPrice < SellList[leftchild].AuxPrice)
                {    min++;   }                               //now min is set to rightchild, otherwise min remains to be the leftchild
            }

            if (SellList[min].AuxPrice < SellList[k].AuxPrice) //compares the k item with the max item and if its less they are swapped
            {
                
                OrderStruct memory temp = SellList[k];    //swap the element at index k with its parent
                SellList[k] = SellList[min];
                SellList[min] = temp;

                k = min; //k is set to min
                leftchild = 2*k + 1; //l is recompuetd in preparation for the next iteration
            }
            else{ //if k item's smaller childer is not smaller than k item itself, heapifyDown should stop
                break;
            }

        }
        return true;
    }



}