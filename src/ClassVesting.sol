// SPDX-License-Identifier: MIT
pragma solidity 0.8.36;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ClassVesting {
    IERC20 public immutable token;

    uint256 public constant BENEFICIARY_COUNT = 7;
    uint256 public constant ALLOCATION = 1_000;
    uint256 public constant CLIFF_UNLOCK = 100;
    uint256 public constant LINEAR_AMOUNT = 900;

    uint256 public immutable cliffTimestamp;
    uint256 public immutable endTimestamp;

    mapping(address => uint256) public allocationOf;
    mapping(address => uint256) public claimedOf;

    event Claimed(address indexed beneficiary, uint256 amount);

    error InvalidTimestamps();
    error InvalidBeneficiaryCount();
    error InvalidBeneficiary();
    error DuplicateBeneficiary();
    error NothingToClaim();

    constructor(
        address token_,
        address[] memory beneficiaries_,
        uint256 cliffTimestamp_,
        uint256 endTimestamp_
    ) {
        if (cliffTimestamp_ >= endTimestamp_) revert InvalidTimestamps();
        if (beneficiaries_.length != BENEFICIARY_COUNT) revert InvalidBeneficiaryCount();

        token = IERC20(token_);
        cliffTimestamp = cliffTimestamp_;
        endTimestamp = endTimestamp_;

        for (uint256 i = 0; i < beneficiaries_.length; i++) {
            address beneficiary = beneficiaries_[i];

            if (beneficiary == address(0)) revert InvalidBeneficiary();
            if (allocationOf[beneficiary] != 0) revert DuplicateBeneficiary();

            allocationOf[beneficiary] = ALLOCATION;
        }
    }

    function vestedAmount(address beneficiary) public view returns (uint256) {
        if (allocationOf[beneficiary] == 0) {
            return 0;
        }

        if (block.timestamp < cliffTimestamp) {
            return 0;
        }

        if (block.timestamp >= endTimestamp) {
            return ALLOCATION;
        }

        uint256 elapsed = block.timestamp - cliffTimestamp;
        uint256 duration = endTimestamp - cliffTimestamp;

        uint256 linearUnlocked = (LINEAR_AMOUNT * elapsed) / duration;

        return CLIFF_UNLOCK + linearUnlocked;
    }

    function releasable(address beneficiary) public view returns (uint256) {
        uint256 vested = vestedAmount(beneficiary);
        uint256 claimed = claimedOf[beneficiary];

        if (vested <= claimed) {
            return 0;
        }

        return vested - claimed;
    }

    function claim() external {
        uint256 amount = releasable(msg.sender);

        if (amount == 0) revert NothingToClaim();

        claimedOf[msg.sender] += amount;

        bool ok = token.transfer(msg.sender, amount);
        require(ok, "TRANSFER_FAILED");

        emit Claimed(msg.sender, amount);
    }
}