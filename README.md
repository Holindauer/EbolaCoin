# EbolaCoin
The Official Cryptocurrency of Ethics Bowl


## What is EbolaCoin?

EBC is a cryptocurrency I created to incentivice people to join the Washington State University Ethics-Bowl team. Members of the WSU Ethics-Bowl team are commonly refered to internally as E-Bolas, short for Ethics Bowlers. Those who attend meetings in person can recieve an EbolaCoin reward.

## Where is EbolaCoin

EbolaCoin is currently live on the Sepolia test net.

- Deployer: 0x0Cca338db059342db73Dd2D41F03e52370dbd46f
- Deployed to: 0x4230ba68ca033b54e67515a6E893181c2984e891
- Transaction hash: 0xf0fcea2f9a48e7e255a57a96a4f7382f8a2a0f39914006a7bf16e1f07a8c30ec

## Protocol

- EbolaCoin is an ERC20 token w/ 6 decimals. 

- As owner of the EbolaCoin smart contract, on ethics bowl meeting days I will set a private integer code in the contract that will be shared with physically present E-Bowl members.

- This code can be redeemed for an amount of 5 EbolaCoin tokens. 

- ETH can also be exchanged for EBC at a fixed rate of 1 ETH --> 1000 EBC. The inverse exchange of EBC --> ETH is also possible.

- As contract owner, the only special privleges I have are the ability to reset the redeemable code once each week, mint new tokens to the contract, as well as set the number of times a single code can be redeemed between resets. The latter I will set to match the number of in person attendees. However, in order for the owner to obtain tokens, I must follow either the code redemption method or direct ETH/EBC exhange like everyone else.

- As an additional note, a single address can only redeem the code once between code resets.


## Note
If it's not too obvious, EbolaCoin is a meme. Use EbolaCoin at your own discretion. It's purpose is mostly just for myself gaining an understanding of the ERC20 standard and for learning to write better solidity.