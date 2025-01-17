// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PetalsToken is ERC20 {
    
    constructor(uint256 initialSupply) ERC20( "Petals", "PTT"){
          _mint(msg.sender, initialSupply);
    }
}
