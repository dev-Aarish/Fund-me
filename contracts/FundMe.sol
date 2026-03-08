//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
Basic Idea of the contract:
1.Get funds from the users
2.Withdraw those deposited funds
3.Set a minimum funding value in USD
*/

//This is the interface used for getting the ABI. We are importing the interface from the gitHub.
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract fundMe{

    uint256 public minimumUSD=5e18;//This is the hardcoded amount of 5$ amt at-least need to be funded.

    function fund() public payable{ //to recieve native blockchain tokens by a function, we need to add the 'payable' keyword
        //Allow user to send $
        //Have a min amt to be funded
        //How do we send ETH to this contract?
        require(getConversionRate(msg.value)>= minimumUSD,"Didn't send enough ETH");   //1e18 wei=1ETH, This value is the field present in the deploy section in remix IDE.
    }

    // function withdraw() public{}

    function getPrice() public view returns(uint256){ //to get the current price of ETH in terms of USD.
        //Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI
        AggregatorV3Interface priceFeed=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price, , , ) = priceFeed.latestRoundData();
        //ETH/USD rate in 18 digit
        return uint256(price*1e10);
    }    

    function getConversionRate(uint256 ethAmount) public view returns(uint256){ //converts a value to its converted value based off of its price.
        uint256 ethPrice=getPrice();
        uint256 ethAmountInUsd=(ethPrice*ethAmount)/1e18;
        return ethAmountInUsd;
    }   

    function getVersion() public view returns(uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
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