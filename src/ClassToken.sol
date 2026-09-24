// SPDX-License-Identifier: MIT
pragma solidity 0.8.36;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ClassToken is ERC20 {
    uint256 public constant TOTAL_SUPPLY = 7_000;

    constructor() ERC20("CS031 Class Token", "CS031") {
        _mint(msg.sender, TOTAL_SUPPLY);
    }

    // Para que totalSupply() sea literalmente 7000, no 7000 * 10^18.
    function decimals() public pure override returns (uint8) {
        return 0;
    }
}