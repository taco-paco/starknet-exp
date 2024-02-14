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

  before(async function () {
    let asd = await starknet.devnet.getPredeployedAccounts();
    let accData = asd[0];
    owner = new Account(provider, accData.address, accData.private_key);
  });

  it("declare", async function () {
    const contractSierra = fs
      .readFileSync(
        "./contracts/target/dev/starknet_hello_world_Balance.contract_class.json"
      )
      .toString("ascii");

    const contractCasm = fs
      .readFileSync(
        "./contracts/target/dev/starknet_hello_world_Balance.compiled_contract_class.json"
      )
      .toString("ascii");

    // Declare & deploy Test contract in devnet
    const compiledTestSierra = json.parse(contractSierra);
    const compiledTestCasm = json.parse(contractCasm);
    const declareResponse = await owner.declare(
      {
        contract: compiledTestSierra,
        casm: compiledTestCasm,
      },
      {
        maxFee: 10 ** 15,
      }
    );

    targetClassHash = declareResponse.class_hash;
    console.log(targetClassHash);
    expect(targetClassHash).to.not.be.empty;
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
    console.log("conntract address:", targetContractAddress);
    expect(targetContractAddress).to.not.be.empty;
  });

  it.only("get", async function () {
    // let callResponse = await owner.callContract({
    //   contractAddress: targetContractAddress,
    //   entrypoint: "get",
    //   calldata: [],
    // });

    const sierra = json.parse(
      fs
        .readFileSync(
          "./contracts/target/dev/starknet_hello_world_Balance.contract_class.json"
        )
        .toString("ascii")
    );

    const myTestContract = new Contract(
      sierra.abi,
      "0x44bed840be645a7db117e324f663f4d4b263b03e3973ce63edb1141f23b0548",
      provider
    );
    myTestContract.connect(owner);

    {
      const res = await myTestContract.get();
      console.log(res);
      console.log("asd");
    }

    {
      let res = await myTestContract.invoke("increase", [1], {
        maxFee: 10 ** 15,
      });
      console.log(res);
      await provider.waitForTransaction(res.transaction_hash);
      console.log("hehehe");
    }

    const asd = await myTestContract.get();
    console.log(asd);
  });
});
