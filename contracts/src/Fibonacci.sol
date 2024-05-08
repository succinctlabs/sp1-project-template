// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {SP1Verifier} from "./SP1Verifier.sol";

/// @title Fibonacci.
/// @author Succinct Labs
/// @notice This contract implements a simple example of verifying the proof of a computing a 
///         fibonacci number.
contract Fibonacci is SP1Verifier {
    /// @notice The verification key for the fibonacci program.
    bytes32 public fibonacciProgramVkey;

    constructor(bytes32 _fibonacciProgramVkey) {
        fibonacciProgramVkey = _fibonacciProgramVkey;
    }

    /// @notice Deserializes the encoded public values into their uint32 components.
    /// @param publicValues The encoded public values.
    function deserializePublicValues(
        bytes memory publicValues
    ) public pure returns (uint32 val1, uint32 val2, uint32 val3) {
        require(
            publicValues.length == 12,
            "public values must be exactly 12 bytes long"
        );
        val1 = readUint32(publicValues, 0);
        val2 = readUint32(publicValues, 4);
        val3 = readUint32(publicValues, 8);
    }

    /// @notice Reads a uint32 from the given data.
    /// @param data The data to convert.
    /// @param startIndex The index to start converting from.
    function readUint32(
        bytes memory data,
        uint startIndex
    ) internal pure returns (uint32) {
        uint32 value;
        assembly {
            value := mload(add(data, add(startIndex, 4)))
        }
        return
            uint32(
                (value & 0xFF) *
                    0x1000000 +
                    ((value >> 8) & 0xFF) *
                    0x10000 +
                    ((value >> 16) & 0xFF) *
                    0x100 +
                    ((value >> 24) & 0xFF)
            );
    }

    /// @notice The entrypoint for verifying the proof of a fibonacci number.
    /// @param proof The encoded proof.
    /// @param publicValues The encoded public values.
    function verifyFibonacciProof(
        bytes memory proof,
        bytes memory publicValues
    ) public view returns (uint32, uint32, uint32) {
        this.verifyProof(fibonacciProgramVkey, publicValues, proof);
        (uint32 n, uint32 a, uint32 b) = deserializePublicValues(publicValues);
        return (n, a, b);
    }
}
