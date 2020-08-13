pragma solidity ^0.6.0;

import "./AdminUpgradeabilityProxy.sol";

// dHedge DAO - https://dhedge.org
//
//      _ _   _           _
//     ( ) ) ( )         ( )
//    _| | |_| |  __    _| |  __    __
//  / _  |  _  |/ __ \/ _  |/ _  \/ __ \
// ( (_| | | | |  ___/ (_| | (_) |  ___/
//  \__ _)_) (_)\____)\__ _)\__  |\____)
//                         ( )_) |
//                          \___/
//
// MIT License
// ===========
//
// Copyright (c) 2020 dHedge
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
// dHedge DAO Token Proxy
//
// Notes          : This contract is a proxy to the dHedge DAO Token.
//                  It allows upgradeability using CALLDELEGATE pattern (code courtesy of https://openzeppelin.org/).
//                  This address should be accessed with the ABI of the current token delegate contract.
//
// ---------------------------------------------------------------------

contract DHedgeTokenProxy is AdminUpgradeabilityProxy {
    constructor(address _implementation, bytes memory _data)
        public
        payable
        AdminUpgradeabilityProxy(_implementation, msg.sender, _data)
    {}
}
