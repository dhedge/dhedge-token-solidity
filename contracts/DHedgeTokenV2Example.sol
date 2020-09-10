pragma solidity ^0.6.0;

import "./DHedgeTokenV1.sol";

// dHEDGE DAO - https://dhedge.org
//
// MIT License
// ===========
//
// Copyright (c) 2020 dHEDGE DAO
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//

contract DHedgeTokenV2Example is DHedgeTokenV1 {
    bool private _upgradedToV2;
    uint256 internal _receivedEther;

    function __DHedgeTokenV2Example_init() public {
        require(!_upgradedToV2, "DHedgeTokenV2Example: already upgraded");
        __DHedgeTokenV2Example_init_unchained();
    }

    function __DHedgeTokenV2Example_init_unchained() internal {
        version = 2;
        _receivedEther = 0;
    }

    function brandNewFunction() public pure returns (string memory) {
        return "Hello";
    }

    //can receive ether
    function brandNewPayableFunction() public payable {
        _receivedEther += msg.value;
    }

    function receivedEther() public view returns (uint256) {
        return _receivedEther;
    }
}
