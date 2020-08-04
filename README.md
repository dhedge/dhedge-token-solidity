# dHedge DAO Token Contracts

First version of the token can be found here: [DHedgeTokenV1.sol](contracts/DHedgeTokenV1.sol)


## Testing with Truffle

Tests also demonstrate how to upgrade the token to a new version: [DHedgeTokenTest.js](test/DHedgeTokenTest.js)

```
npm i 

truffle(develop)> test

  Contract: DHedgeTokenTest
    ✓ First version of token is initialized correctly (217ms)
    ✓ Token upgrade 2in1 works correctly (229ms)
    ✓ Token upgrade 1by1 works correctly (245ms)
    ✓ Can transfer tokens to any address (79ms)
    ✓ Anyone can burn tokens (194ms)
    ✓ Token refuses to accept ether transfers

  6 passing (2s)

```

