/// @file     TestAll.ts
/// @brief    The main file for running all tests.
/// @author   Paco Edwin
/// @date     13-Apr-2022

// This file is a property of ShardLabs.

import fs from "fs";
import axios from "axios";
import { starknet } from "hardhat";
import {
  Account,
  CallData,
  Contract,
  ContractFactory,
  Provider,
  RpcProvider,
  json,
} from "starknet";
import { expect } from "chai";

const provider = new Provider({ rpc: { nodeUrl: "http://127.0.0.1:5050" } });

const sierra = json.parse(
  fs
    .readFileSync(
      "./contracts/target/dev/starknet_hello_world_Balance.contract_class.json"
    )
    .toString("ascii")
);
const casm = json.parse(
  fs
    .readFileSync(
      "./contracts/target/dev/starknet_hello_world_Balance.compiled_contract_class.json"
    )
    .toString("ascii")
);

async function mint(address: string, amount: number, lite = true) {
  await axios.post(`${starknet.networkConfig.url}/mint`, {
    amount,
    address,
    lite,
  });
}

describe("All contract tests", function () {
  this.timeout(600_000);

  let owner: Account;

  let targetClassHash: string;
  let targetContractAddress: string;
  let targetContract: Contract;

  before(async function () {
    let asd = await starknet.devnet.getPredeployedAccounts();
    let accData = asd[0];
    owner = new Account(provider, accData.address, accData.private_key);
  });

  it("declare", async function () {
    const declareResponse = await owner.declare(
      {
        contract: sierra,
        casm: casm,
      },
      {
        maxFee: 10 ** 15,
      }
    );

    targetClassHash = declareResponse.class_hash;
    expect(targetClassHash).to.not.be.empty;

    console.log("class_hash:", targetClassHash);
  });

  it("deploy", async function () {
    let deployResponse = await owner.deployContract(
      {
        classHash: targetClassHash,
        constructorCalldata: [0],
      },
      {
        maxFee: 10 ** 15,
      }
    );
    await provider.waitForTransaction(deployResponse.transaction_hash);

    targetContractAddress = deployResponse.contract_address;
    expect(targetContractAddress).to.not.be.empty;

    console.log("contract_address:", targetContractAddress);

    // Init contract instance
    targetContract = new Contract(sierra.abi, targetContractAddress, provider);
    targetContract.connect(owner);
  });

  it("increase", async function () {
    let { transaction_hash } = await targetContract.invoke("increase", [10], {
      maxFee: 10 ** 15,
    });
    await provider.waitForTransaction(transaction_hash);
  });

  it("get", async function () {
    const res = await targetContract.get();
    console.log(res);
  });
});
