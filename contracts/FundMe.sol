//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
Basic Idea of the contract:
1.Get funds from the users
2.Withdraw those deposited funds
3.Set a minimum funding value in USD
*/

contract fundMe{
    function fund() public payable{
        //Allow user to send $
        //Have a min amt to be funded
        //How do we send ETH to this contract?
        require(msg.value>1 ether,"Didn't send enough ETH");   //1e18 wei=1ETH, This value is the field present in the deploy section in remix IDE.
    }

    // function withdraw() public{}

}

/*
What I got to learn:
1. Sending ETH through a function
    The "value" in the 'deploy and run txn' can be used to mention the amt to tokens(ETH) that can be sent to some other users.
    The keyword "payable" is used for token handling for a function. This also make the button red in the after deployment of the contract.
*/