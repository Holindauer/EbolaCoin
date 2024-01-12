// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {EbolaCoin} from "../src/EbolaCoin.sol";
import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";


contract EbolaCoinTest is Test {
    EbolaCoin public ebolaCoin;
    address public owner;

    function setUp() public {
        owner = address(100);
    }

    /// @notice this test ensures the contract is deployed correctly and the initial supply is minted to the contract
    function testEBCDeployment() public {

        /// set caller as the owner
        vm.prank(owner);

        // owner deploys the ebola coin contract with an initial supply of 10 thousand tokens
        uint initialSupply = 10_000;
        ebolaCoin = new EbolaCoin(initialSupply);

        // check that the owner was assigned correctly
        require(ebolaCoin.owner() == owner, "Owner is not the caller");

        // check that the initial supply was minted to the contract
        require(
            ebolaCoin.balanceOf(address(ebolaCoin)) == initialSupply * (10 ** uint256(ebolaCoin.decimals())), 
            "Initial supply was not minted to the contract"
            );
    }

    function testCodeSetRedemption() public {

        /// set caller as the owner
        vm.prank(owner);

        // owner deploys the ebola coin contract with an initial supply of 10 thousand tokens
        uint initialSupply = 10_000;
        ebolaCoin = new EbolaCoin(initialSupply);
        require(
            ebolaCoin.owner() == owner, 
            "Owner is not the contract creator"
            );

        // initial code should be 0 after construction
        uint code = 0; 

        // owner should not have funds after contract creations
        require(ebolaCoin.balanceOf(owner) == 0, "Owner balance is not 0 after deploying contract");

        // after redeeming the code, owner should have 5 * (10 ** decimals()) tokens
        vm.prank(owner);
        ebolaCoin.redeemCode(code);
        require(
            ebolaCoin.balanceOf(owner) == 5 * (10 ** uint256(ebolaCoin.decimals())), 
            "Owner balance is not 5 * (10 ** decimals()) tokens"
            );

    }
}
