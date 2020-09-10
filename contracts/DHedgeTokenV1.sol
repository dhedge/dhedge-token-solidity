pragma solidity ^0.6.0;

import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/Initializable.sol";

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
// ---------------------------------------------------------------------
// dHedge DAO ERC20 Token
//
// Symbol         : DHT
// Name           : dHedge DAO Token
// Decimals       : 18
// Total supply   : 100,000,000
// Version        : 1
//
// Notes          : This token is upgradable using CALLDELEGATE pattern (courtesy of https://openzeppelin.org/).
//                  It should NOT be accessed directly but through the proxy contract address using this contract's ABI.
// ---------------------------------------------------------------------

contract DHedgeTokenV1 is Initializable, ERC20BurnableUpgradeSafe {
    uint256 public version;

    function __DHedgeTokenV1_init(address initialAccount) public initializer {
        __Context_init_unchained();
        __ERC20_init_unchained("dHedge DAO Token", "DHT");
        __ERC20Burnable_init_unchained();
        __DHedgeTokenV1_init_unchained(initialAccount, 100000000 * (10**18));
    }

    function __DHedgeTokenV1_init_unchained(
        address initialAccount,
        uint256 initialBalance
    ) internal initializer {
        version = 1;

        _mint(initialAccount, initialBalance);
    }

    uint256[50] private __gap;
}
