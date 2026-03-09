//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
Basic Idea of the contract:
1.Get funds from the users
2.Withdraw those deposited funds
3.Set a minimum funding value in USD
*/

//This is the interface used for getting the ABI. We are importing the interface from the gitHub.
// import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract fundMe{

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD=5e18;//This is the hardcoded amount of 5$ amt at-least need to be funded.
    address[] public funders;
    mapping(address funder =>uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor(){
        i_owner=msg.sender;
    }

    function fund() public payable{ //to recieve native blockchain tokens by a function, we need to add the 'payable' keyword
        //Allow user to send $
        //Have a min amt to be funded
        //How do we send ETH to this contract?
        require(msg.value.getConversionRate()>= MINIMUM_USD,"Didn't send enough ETH");   //1e18 wei=1ETH, This value is the field present in the deploy section in remix IDE.
        //In the above line of code, we imported the function getConversionRate from the PriceConverter lib and point to be noted, that even though getConversionRate function takes one uint256, nothing id passes as an arg.
        //That is becasue the msg.value itself gets passed as the parameter in the function while calling.
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]+=msg.value;
    }

    function withdraw() public onlyOwner{
        
        for(uint256 funderIndex=0;funderIndex<funders.length;funderIndex++){
            address funder=funders[funderIndex];
            addressToAmountFunded[funder]=0;

        }
        funders=new address[](0);   //resetting the array

        //transfer
        // payable(msg.sender).transfer(address(this).balance);

        //send
        // bool sendSuccess=payable(msg.sender).send(address(this).balance); 
        // require(sendSuccess,"Send failed");

        //call
        (bool callSuccess,)=payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"Call failed");
    }

    modifier onlyOwner(){
        // require(msg.sender==i_owner,"Must be the owner!");
        if(msg.sender!=i_owner){
            revert NotOwner();
        }
        _;
    }

    receive() external payable{
        fund();
    }

    fallback() external payable{
        fund();
    }

}

/*
What I got to learn:
1. Sending ETH through a function
    The "value" in the 'deploy and run txn' can be used to mention the amt to tokens(ETH) that can be sent to some other users.
    The keyword "payable" is used for token handling for a function. This also make the button red in the after deployment of the contract.
2. What is a revert?
    Undo any action that has been done, and send the remaining gas back. 
    Which basically means, that all the modifications that has been done(state modification) during the running of the function will be changed back to its normal state.
3. Chainlink : Decentralized Oracle Network
    The USD price of assets like Ethereum cannot be derived from blockchain technolofy alone but it is determined by the financial markets.
    To obtain a correct price info, a connection b/w off-chain and on-chain data is necessary. This is facilitated by a decentralized Oracle n/w.  
4. Interface        
*/