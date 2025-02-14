// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {Fibonacci} from "../src/Fibonacci.sol";
import {SP1Verifier as SP1VerifierGroth16, Groth16Verifier} from "@sp1-contracts/v4.0.0-rc.3/SP1VerifierGroth16.sol";
import {SP1Verifier as SP1VerifierPlonk} from "@sp1-contracts/v4.0.0-rc.3/SP1VerifierPlonk.sol";
import {SP1VerifierGateway} from "@sp1-contracts/SP1VerifierGateway.sol";

struct SP1ProofFixtureJson {
    uint32 a;
    uint32 b;
    uint32 n;
    bytes proof;
    bytes publicValues;
    bytes32 vkey;
}

contract FibonacciGroth16Test is Test {
    using stdJson for string;

    SP1VerifierGroth16 internal verifier;
    Fibonacci public fibonacci;

    function loadFixture() public view returns (SP1ProofFixtureJson memory) {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/src/fixtures/groth16-fixture.json");
        string memory json = vm.readFile(path);
        bytes memory jsonBytes = json.parseRaw(".");
        return abi.decode(jsonBytes, (SP1ProofFixtureJson));
    }

    function setUp() public {
        SP1ProofFixtureJson memory fixture = loadFixture();
        verifier = new SP1VerifierGroth16();
        fibonacci = new Fibonacci(address(verifier), fixture.vkey);
    }

    function test_ValidFibonacciProof() public view {
        SP1ProofFixtureJson memory fixture = loadFixture();

        (uint32 n, uint32 a, uint32 b) = fibonacci.verifyFibonacciProof(fixture.publicValues, fixture.proof);
        assert(n == fixture.n);
        assert(a == fixture.a);
        assert(b == fixture.b);
    }

    function test_RevertInvalidFibonacciProof() public {
        SP1ProofFixtureJson memory fixture = loadFixture();

        // Create a fake proof.
        // The first 4 bytes are from the verifier hash to ensure for the correct verifier
        bytes memory fakeProof = bytes.concat(bytes4(verifier.VERIFIER_HASH()), new bytes(fixture.proof.length - 4));

        vm.expectRevert(abi.encodeWithSelector(Groth16Verifier.ProofInvalid.selector));
        fibonacci.verifyFibonacciProof(fixture.publicValues, fakeProof);
    }
}

contract FibonacciPlonkTest is Test {
    using stdJson for string;

    SP1VerifierPlonk internal verifier;
    Fibonacci public fibonacci;

    function loadFixture() public view returns (SP1ProofFixtureJson memory) {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/src/fixtures/plonk-fixture.json");
        string memory json = vm.readFile(path);
        bytes memory jsonBytes = json.parseRaw(".");
        return abi.decode(jsonBytes, (SP1ProofFixtureJson));
    }

    function setUp() public {
        SP1ProofFixtureJson memory fixture = loadFixture();

        verifier = new SP1VerifierPlonk();
        fibonacci = new Fibonacci(address(verifier), fixture.vkey);
    }

    function test_ValidFibonacciProof() public view {
        SP1ProofFixtureJson memory fixture = loadFixture();

        (uint32 n, uint32 a, uint32 b) = fibonacci.verifyFibonacciProof(fixture.publicValues, fixture.proof);
        assert(n == fixture.n);
        assert(a == fixture.a);
        assert(b == fixture.b);
    }

    function test_RevertInvalidFibonacciProof() public {
        SP1ProofFixtureJson memory fixture = loadFixture();

        // Create a fake proof.
        // The first 4 bytes are from the verifier hash to ensure for the correct verifier
        bytes memory fakeProof = bytes.concat(bytes4(verifier.VERIFIER_HASH()), new bytes(fixture.proof.length - 4));

        // The plonk verifier throws slightly differently than groth16, so we just check that is reverts
        vm.expectRevert();
        fibonacci.verifyFibonacciProof(fixture.publicValues, fakeProof);
    }
}
