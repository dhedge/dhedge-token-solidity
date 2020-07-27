# dHedge DAO Token Contracts

First version of the token can be found here: [DHedgeTokenV1.sol](contracts/DHedgeTokenV1.sol)


## Testing with Truffle

Tests also demonstrate how to upgrade the token to a new version: [DHedgeTokenTest.js](test/DHedgeTokenTest.js)

```
truffle(develop)> test

  Contract: DHedgeTokenTest
    ✓ First version of token is initialized correctly (115ms)
    ✓ Token upgrade 2in1 works correctly (188ms)
    ✓ Token upgrade 1by1 works correctly (229ms)
    ✓ Can transfer tokens to any address (63ms)
    ✓ Anyone can burn tokens (139ms)
    ✓ Token refuses to accept ether transfers
    ✓ ApproveAndCall works correctly (221ms)


  7 passing (2s)
```

