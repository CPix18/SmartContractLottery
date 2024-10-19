// SPDX-License_Identifier: MIT

pragma solidity ^0.8.26;

contract ExampleModulo {
    function getModTen(uint256 number) external pure returns (uint256) {
        return number % 10;
    }

    function getModTwo(uint256 number) external pure returns (uint256) {
        return number % 2;
    }
}
