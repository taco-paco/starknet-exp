/// @file     TestAll.ts
/// @brief    The main file for running all tests.
/// @author   Paco Edwin
/// @date     13-Apr-2022

// This file is a property of ShardLabs.

import { starknet } from "hardhat";
import { getSelectorFromName } from "starknet/dist/utils/hash";
import { Account } from "hardhat/types/runtime";

describe("All contract tests", function () {
  this.timeout(600_000);

  let account: Account;

  before(async () => {
    account = await starknet.deployAccount("OpenZeppelin");
  });

  it.only("Diamond", async () => {
    const fac = await starknet.getContractFactory("D");
    const d = await fac.deploy();

    console.log(await d.call("getVal"));
    console.log(await d.call("getBA"), await d.call("getCA"));

    await account.invoke(d, "setBA", {
      val: 2,
    });

    console.log(
      await d.call("getBA"),
      await d.call("getCA"),
      await d.call("getA")
    );

    await account.invoke(d, "setCA", {
      val: 3,
    });

    console.log(
      await d.call("getBA"),
      await d.call("getCA"),
      await d.call("getA")
    );
  });

  it.skip("Delegate tests", async () => {
    const delegeeFac = await starknet.getContractFactory("delegee");
    const delegee_hash = await account.declare(delegeeFac);

    const delegateFac = await starknet.getContractFactory("delegate");
    const delegate = await delegateFac.deploy({ class_hash: delegee_hash });
    await account.invoke(delegate, "delegateCall", {
      class_hash: delegee_hash,
      selector: getSelectorFromName("delegee"),
      calldata: [],
    });

    console.log(await delegate.call("getAddress"));
    console.log(await delegate.call("getSender"));

    console.log(delegate.address, account.starknetContract.address);

    console.log(
      await delegate.call("getData", {
        selector: getSelectorFromName("getAddress"),
      })
    );

    console.log(
      await delegate.call("getData", {
        selector: getSelectorFromName("getSender"),
      })
    );

    {
      await account.invoke(delegate, "setData", {
        selector: getSelectorFromName("delegee"),
      });

      console.log(
        await delegate.call("getData", {
          selector: getSelectorFromName("getAddress"),
        })
      );

      console.log(
        await delegate.call("getData", {
          selector: getSelectorFromName("getSender"),
        })
      );
    }
  });

  it.skip("sys attempt", async () => {
    const inheritenceFactory = await starknet.getContractFactory(
      "contracts/Inheritence/Inheritence.cairo"
    );
    const inheritenceContract = await inheritenceFactory.deploy();

    const res = await account.invoke(inheritenceContract, "call_sys_raw_input");
  });

  it.skip("Test raw input", async () => {
    const inheritenceFactory = await starknet.getContractFactory(
      "contracts/Inheritence/Inheritence.cairo"
    );
    const inheritenceContract = await inheritenceFactory.deploy();

    const res = await account.invoke(inheritenceContract, "call_raw_input", {
      calldata: [1, 1],
    });
  });

  it.skip("Test raw input", async () => {
    const inheritenceFactory = await starknet.getContractFactory(
      "contracts/Inheritence/Inheritence.cairo"
    );
    const inheritenceContract = await inheritenceFactory.deploy();
    //console.log("inheritenceContract addr", inheritenceContract.address);

    const res = await account.call(
      inheritenceContract,
      "test_raw_input",
      {
        selector: 22,
        calldata: [1, 1],
      },
      { maxFee: 10000 }
    );
    console.log("res", res);

    // const res = await inheritenceContract.invoke("test_raw_input", {
    //   selector: 22,
    //   calldata: [1, 1],
    // });
    // console.log(res);
  });

  it.skip("Test address return", async () => {
    let inheritenceFactory = await starknet.getContractFactory(
      "contracts/Inheritence/Inheritence.cairo"
    );
    let inheritenceContract = await inheritenceFactory.deploy();
    //await account.invoke(inheritenceContract, "increaseLol");

    await account.invoke(inheritenceContract, "deposit", {
      from_address: account.starknetContract.address,
      value: 1,
    });
  });

  it("Test call_contract", async () => {
    let inheritenceFactory = await starknet.getContractFactory(
      "contracts/Inheritence/Inheritence.cairo"
    );
    let inheritenceContract = await inheritenceFactory.deploy();
    //console.log(await account.call(inheritenceContract, 'getLol'));

    const selector = getSelectorFromName("asd");
    const target = inheritenceContract.address;
    const payload = {
      to: target,
      function_selector: selector,
      calldata: [2],
    };

    console.log(payload);

    const res = await account.invoke(inheritenceContract, "callF", payload);
    console.log(res);
    console.log(await account.call(inheritenceContract, "getOriginAndCaller"));
    //console.log(await account.call(inheritenceContract, 'getLol'));
  });

  it.skip("Test interface", async () => {
    let inheritenceFactory = await starknet.getContractFactory(
      "contracts/FinalInheritence.cairo"
    );
    let inheritenceContract = await inheritenceFactory.deploy();
    await account.invoke(inheritenceContract, "increaseLol");
    console.log(await account.call(inheritenceContract, "getLol"));

    await account.invoke(inheritenceContract, "callInherited");
    console.log(await account.call(inheritenceContract, "getLol"));
  });

  it.skip("Test delegate", async () => {
    let inheritenceFactory = await starknet.getContractFactory(
      "contracts/Inheritence/Inheritence.cairo"
    );
    let inheritenceContract = await inheritenceFactory.deploy();

    let inheritence2Factory = await starknet.getContractFactory(
      "contracts/Inheritence/Inheritence2.cairo"
    );
    let inheritence2Contract = await inheritence2Factory.deploy({
      anotherContractAddress: inheritenceContract.address,
    });

    console.log(await account.invoke(inheritence2Contract, "delegateGetLol"));
  });

  it.skip("Test txInfo", async () => {
    let inheritenceFactory = await starknet.getContractFactory(
      "contracts/Inheritence/Inheritence.cairo"
    );
    let inheritenceContract = await inheritenceFactory.deploy();

    let inheritence2Factory = await starknet.getContractFactory(
      "contracts/Inheritence2.cairo"
    );
    let inheritence2Contract = await inheritence2Factory.deploy({
      anotherContractAddress: inheritenceContract.address,
    });

    let { origin: originAddress, caller: callerAddress } = await account.call(
      inheritence2Contract,
      "getOriginAndCaller"
    );
    console.log(
      account.starknetContract.address,
      originAddress.toString(16),
      callerAddress.toString(16)
    );
  });

  it.skip("Test owned", async () => {
    let mainContractFactory = await starknet.getContractFactory(
      "contracts/Inheritence/Inheritence.cairo"
    );
    let mainContract = await mainContractFactory.deploy();

    let { origin: originAddress } = await account.call(
      mainContract,
      "getTxInfoVal"
    );
    console.log(account.starknetContract.address);
    console.log("originAddress", originAddress.toString(16));
  });

  it.skip("Test owned", async () => {
    let mainContractFactory = await starknet.getContractFactory(
      "contracts/Inheritence/Inheritence.cairo"
    );
    let mainContract = await mainContractFactory.deploy();

    let { lol: address } = await account.call(mainContract, "getLol");
    console.log("acc add", account.starknetContract.address);
    console.log("contr", mainContract.address);
    console.log("address", address.toString(16));
  });

  it.skip("Test inheritence", async () => {
    let inheritenceFactory = await starknet.getContractFactory(
      "contracts/Inheritence/Inheritence.cairo"
    );
    let inheritenceContract = await inheritenceFactory.deploy();

    // let inheritence2Factory = await starknet.getContractFactory('contracts/Inheritence2.cairo');
    // let inheritence2Contract = await inheritence2Factory.deploy({ anotherContractAddress: inheritenceContract.address });

    // console.log(await account.call(inheritenceContract, 'getLol'));

    const res = await account.invoke(inheritenceContract, "increaseLol");
    console.log(await starknet.getTransactionReceipt(res));
    console.log(await account.call(inheritenceContract, "getLol"));

    // await account.invoke(inheritence2Contract, 'increaseLol');
    // console.log(await account.call(inheritenceContract, 'getLol'));
  });

  it.skip("Test delegate", async () => {
    let inheritenceFactory = await starknet.getContractFactory(
      "contracts/Inheritence/Inheritence.cairo"
    );
    let inheritenceContract = await inheritenceFactory.deploy();

    let inheritence2Factory = await starknet.getContractFactory(
      "contracts/Inheritence2.cairo"
    );
    let inheritence2Contract = await inheritence2Factory.deploy({
      anotherContractAddress: inheritenceContract.address,
    });

    console.log(await account.call(inheritenceContract, "getLol"));

    await account.invoke(inheritenceContract, "increaseLol");
    console.log(await account.call(inheritenceContract, "getLol"));

    await account.invoke(inheritence2Contract, "delegateIncreaseLol");
    console.log(await account.call(inheritence2Contract, "getLol"));
  });
});
