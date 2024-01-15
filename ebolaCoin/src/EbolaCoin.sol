// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract EbolaCoin is ERC20 {
    
    address public immutable owner;

    /// @dev the code can be used to redeem tokens numRedemptions times before being reset
    uint private code;
    uint8 private numRedemptions;

    /// @dev resetTime is the time at which the owner most recently reset the code and number of redemptions
    uint private resetTime;

    /// @dev conversionRateETH is the number of tokens that can be purchased with 1 ETH
    uint public immutable conversionRateETH = 1000;

    /**
    * @notice EbolaCoin is constructed as an ERC20 token with the name "EbolaCoin" and the symbol "EBC"
    * @dev The owner sets an initial supply of tokens that is minted to the contract
    * @param _initialSupply is the initial supply of tokens minted to the contract prior to multiplying
    * by 10^decimals()
    */
    constructor(uint _initialSupply) ERC20("EbolaCoin", "EBC") {
        owner = msg.sender;

        /// @dev decimals() is overridden to return 6
        uint256 initialSupply = _initialSupply * (10 ** uint256(decimals()));

        /// The contract is minted with the initial supply 
        _mint(address(this), initialSupply);

        /// set initial code to 0 and number of redemptions to 1
        code = 0;
        numRedemptions = 1;

        // set resetTime to the current block timestamp
        resetTime = block.timestamp;
    }

    /// @notice Override decimals to be 6 instead of the default 18
    function decimals() public pure override returns (uint8) {
        return 6;
    }

    /// @notice Modifier to restrict access to the owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    /// @notice only owner function to mint mint more tokens to the contract
    /// @dev new tokens are only minted to the contract, not to the owner. The only way for an 
    /// externally owned account to recieve tokens is either by redeeming the code or by purchasing 
    /// them.
    function mint(uint256 amount) public onlyOwner {

        // mint new tokens to the contract balance
        _mint(address(this), amount);
    }

    /**
    * @notice owner can set a new code for redeeming tokens that can be redeemed numRedemptions times
    * @dev uint8 has a max value of 255, so the max number of redemptions is 255 
    * @param _code is the new code for redeeming tokens, the code is set by thw owner and is revealed in person
    * @param _numRedemptions is the number of times the code can be redeemed before it is reset
     */
    function setCode(uint256 _code, uint8 _numRedemptions) public onlyOwner{

        require(
            resetTime + 1 weeks < block.timestamp, 
            "Code can only be reset once per week"
            );

        // set the code and number of redemptions
        code = _code;
        numRedemptions = _numRedemptions;

        // set new resetTime
        resetTime = block.timestamp;
    }

    /// @notice anyone can redeem the code for 5 tokens while numRedemptions > 0
    function redeemCode(uint256 _code) public {

        // ensure that the code is correct
        require(code == _code, "Code is not correct");

        // ensure that the code has not been redeemed more than numRedemptions times
        require(numRedemptions > 0, "Code has been redeemed too many times");

        // decrement the number of redemptions
        numRedemptions -= 1;

        // transfer 5 tokens to the caller
        _transfer(address(this), msg.sender, 5 * (10 ** uint256(decimals())));   
    }

    /**
    * @notice ETH can be converted to EbolaCoin tokens at a rate of 1000 tokens per ETH
    * @dev the conversion of Eth to EBC is done with the followiung formula:
    * Token Amount = wei * ((conversionRateETH / 10^18) / 10^6) = wei * (conversionRateETH / 10^12)
    * Where 10^18 is the number of wei in 1 ETH and 10^6 is the number of decimals in EBC
     */
    function convertETHtoEBC() public payable {

        // convert msg.value to tokens
        uint256 amount = conversionRateETH * (msg.value / (10 ** 12));

        // transfer tokens to the caller
        _transfer(address(this), msg.sender, amount);
    }

    /// @notice EbolaCoin tokens can be converted to ETH at a rate of 1000 tokens per ETH
    /// @dev amount needs to already have been multiplied by 10^decimals()
    function convertEBCtoETH(uint256 amount) public {

        // convert tokens to ETH
        uint256 ethAmount = amount  / conversionRateETH;

        // require the contract to have the amount of ETH required to convert
        require(
            address(this).balance >= ethAmount, 
            "Contract does not have enough ETH to run EBC->ETH conversion"
            );

        // transfer tokens from the caller to the contract
        _transfer(msg.sender, address(this), amount);


        // transfer ETH to the caller
        payable(msg.sender).transfer(ethAmount);
    }


    /// TODO use a linked list to determine who has already redeemed the code
}
