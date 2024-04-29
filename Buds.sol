// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BudsToken is ERC20 {
    constructor() ERC20("Buds token", "BUDS"){
        _mint(_msgSender(), 420_000_000 ether);
    }

    function mint() external {
        _mint(_msgSender(), 1000 ether);
    }
}