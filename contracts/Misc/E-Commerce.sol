//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Ecommerce{
    
    struct Product{
        string title;
        string description;
        address payable seller;
        uint productId;
        uint price;
        address buyer;
        bool delivered;
    } 

    Product [] public products;  // array of type "Product struct"
    uint counter = 0;

    event registered(string title, uint productId, address seller);
    event bought(uint productId, address buyer);
    event delivered(uint productId);

    // function is used for registering the product
    function registerProduct
        (string memory _title,
        string memory _description,
        uint _price)
        public {
            require(_price > 0 , "Price of products has to be greater then 0");
            Product memory tempProduct;
            tempProduct.title = _title;
            tempProduct.description = _description;
            tempProduct.price = _price * 10**18;
            tempProduct.seller = payable(msg.sender);//BUG: The address of the seller should be a payable address so that it can recieve some ether whenever paid by someone
            tempProduct.productId = counter;
            products.push(tempProduct);
            counter++; //BUG: This statement is needed to increment the ID of new product added so that each product gets unique ID.
            emit registered(_title,tempProduct.productId, msg.sender);
        }    
        
     // funtion to buy the product
    function buy(uint _productId) payable public{// BUG: buy function should be payable otherwise it will not allow the buyer to send ethers to the seller
        require(products[_productId].price == msg.value,"Please pay the exact amount");// BUG: In require statement, the price of the product should be exactly equal to the value paid by the buyer and not greater than that
        require(products[_productId].seller!=msg.sender,"Seller cannot be the buyer");// BUG: This statement is required as the one who is registering the product cannot buy it
        products[_productId].buyer  = msg.sender;
        emit bought(_productId, msg.sender); //BUG: The second parameter i.e address of the buyer was not passed
    }
 
    // function to confirm delivery from buyer
    function delivery(uint _productId) public {
        require(products[_productId].buyer == msg.sender, "buyer confirmation only");
        products[_productId].delivered = true;
        products[_productId].seller.transfer(products[_productId].price);
        emit delivered(_productId);
    } 
}
