// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {EbolaCoin} from "../src/EbolaCoin.sol";
import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";


contract EbolaCoinTest is Test {
    EbolaCoin public ebolaCoin;
    address public owner;
    uint initialSupply;

    function setUp() public {

        owner = address(100);

        /// set caller as the owner
        vm.prank(owner);

        // owner deploys the ebola coin contract with an initial supply of 10 thousand tokens
        initialSupply = 10_000;
        ebolaCoin = new EbolaCoin(initialSupply);

        // Deal the contract 1 ETH (Contract needs ETH to make the conversion)
        vm.deal(address(ebolaCoin), 1 ether);
    }

    /// @notice this test ensures the contract is deployed correctly and the initial supply is minted to the contract
    function testEBCDeployment() public {

        // check that the owner was assigned correctly
        require(ebolaCoin.owner() == owner, "Owner is not the caller");

        // check that the initial supply was minted to the contract
        require(
            ebolaCoin.balanceOf(address(ebolaCoin)) == initialSupply * (10 ** uint256(ebolaCoin.decimals())), 
            "Initial supply was not minted to the contract"
            );
    }

    function testCodeSetRedemption() public {

        // initial code should be 0 after construction
        uint code = 0; 

        // owner should not have funds after contract creations
        require(
            ebolaCoin.balanceOf(owner) == 0, 
            "Owner balance is not 0 after deploying contract"
            );

        // after redeeming the code, owner should have 5 * (10 ** decimals()) tokens
        vm.prank(owner);

        // Owner redeems the initial code
        ebolaCoin.redeemCode(code);
        require(
            ebolaCoin.balanceOf(owner) == 5 * (10 ** uint256(ebolaCoin.decimals())), 
            "Owner balance is not 5 * (10 ** decimals()) tokens"
            );
    }

    /**
    * @notice this test runs a conversion from EBC tokens to ETH/
    * @dev in order to make the conversion, the contract needs to have the appropriate amount of ETH
    */
    function testConversionEBCtoETH() public {

        // initial code should be 0 after construction
        uint code = 0; 

        // after redeeming the code, owner should have 5 * (10 ** decimals()) tokens
        vm.prank(owner);
        ebolaCoin.redeemCode(code);

        // owner should have 5 tokens after redeeming the code
        uint ownerBalance =  5 * (10 ** ebolaCoin.decimals());

        // owner converts 5 tokens to ETH
        vm.prank(owner);
        ebolaCoin.convertEBCtoETH(ownerBalance);

        // owner should have 0 tokens after converting to ETH
        require(
            ebolaCoin.balanceOf(owner) == 0, 
            "Owner balance is not 0 after converting to ETH"
            );

        // owner should have 5 * (10 ** decimals()) ETH after converting to ETH
        require(
            address(owner).balance == ownerBalance /1000, 
            "Owner ETH balance is not 1/1000 num EBC tokens after converting to ETH"
            );

    }

    /**
    * @notice this test runs a conversion from ETH to EBC tokens
     */
    function testConversionETHtoEBC() public payable {

        // deal the owner 1 ETH
        vm.deal(owner, 1 ether);

        // owner should have 0 tokens after converting to ETH
        require(
            ebolaCoin.balanceOf(owner) == 0, 
            "Owner balance is not 0 after converting to ETH"
            );

        // Owner purchases 1 ETH worth of EBC tokens
        vm.prank(owner);
        ebolaCoin.convertETHtoEBC{value: 1 ether}();

        // owner should have 1000 EbolaCoin tokens after converting to ETH
        require(
            ebolaCoin.balanceOf(owner) == 1000 * (10 ** uint256(ebolaCoin.decimals())), 
            "Owner EBC balance is not 1000 * (10 ** decimals()) tokens after converting to ETH"
        );
    }
}