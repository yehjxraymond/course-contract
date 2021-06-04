const { expect } = require("chai");
const { BigNumber, utils } = require("ethers");
const { deployAllLevels } = require("../src/deployLevels");

describe("CourseContract", () => {
  it("should work as expected", async () => {
    const [owner, addr1] = await ethers.getSigners();

    const CourseContract = await ethers.getContractFactory("CourseContract");
    const courseContract = await CourseContract.deploy("Course Token", "CTK");

    await courseContract.deployed();

    const tokenAddress = await courseContract.courseToken();
    const courseToken = await ethers.getContractAt("CourseToken", tokenAddress);

    const [
      helloWorld,
      readAndWrite,
      myBlockNumber,
      wishingWell,
      dirtyDirtySecret,
      selectMeNot,
      findMyABI,
      hashCrack,
      heSaysSheSays,
      noticeBoard,
      hitMeBabyOneMoreTime,
      imFeelingLucky,
      jiXiangKat,
      spendthrift,
      iRobot,
      moneyLaunderer,
      mathOlympiad,
    ] = await deployAllLevels(courseContract, ethers, false);

    // Challenger can attempt level and be awarded tokens
    await helloWorld.connect(addr1).helloWorld();
    await expect(await courseToken.balanceOf(addr1.address)).to.equal(
      BigNumber.from("10000000000000000000")
    );

    // Other challengers can attempt the same level
    await helloWorld.helloWorld();
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("10000000000000000000")
    );

    // Challenger may not attempt challenge again
    await expect(helloWorld.connect(addr1).helloWorld()).to.be.revertedWith(
      "Challenger has completed level before"
    );

    // Attempt ReadAndWrite
    const readAndWriteAns = await readAndWrite.notSoSecret();
    await readAndWrite.submit(readAndWriteAns);
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("20000000000000000000")
    );

    // Attempt MyBlockNumber
    const nextBlockNumber = (await owner.provider.getBlockNumber()) + 1;
    await myBlockNumber.submit(nextBlockNumber);
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("30000000000000000000")
    );

    // Attempt WishingWell
    await owner.sendTransaction({
      to: wishingWell.address,
      value: utils.parseEther("0.1"),
    });
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("40000000000000000000")
    );

    // Attempt DirtyDirtySecret
    const dirtySecret = await owner.provider.getStorageAt(
      dirtyDirtySecret.address,
      3
    );
    await dirtyDirtySecret.submit(dirtySecret);
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("60000000000000000000")
    );

    // Attempt SelectMeNot (selectMeNot(bytes4))
    // https://emn178.github.io/online-tools/keccak_256.html
    await selectMeNot.selectMeNot("0x38c1f6d3");
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("70000000000000000000")
    );

    // Attempt FindMyABI
    await findMyABI.initiate();
    await findMyABI.meaningOfLife(42);
    await findMyABI.noMoneyNoHoney({ value: "0x01" });
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("80000000000000000000")
    );

    // Attempt HashCrack
    await hashCrack.submit(52);
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("100000000000000000000")
    );

    // Attempt HeSaysSheSays
    await heSaysSheSays.connect(addr1).submit(owner.address);
    await heSaysSheSays.submit(addr1.address);
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("110000000000000000000")
    );

    // Attempt NoticeBoard
    await noticeBoard.scribble(owner.address, utils.hexZeroPad("0x01", 32));
    await noticeBoard.submit();
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("120000000000000000000")
    );

    // Exploit NoticeBoard
    // https://programtheblockchain.com/posts/2018/03/09/understanding-ethereum-smart-contract-storage/
    const Storage = await ethers.getContractFactory("Storage");
    const storage = await Storage.deploy();
    await storage.deployed();
    const slotNo = await storage.reverseArrLocation(3, 1, 1);
    await noticeBoard.scribble(
      slotNo,
      utils.hexZeroPad(
        "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
        32
      )
    );
    await noticeBoard.scribble(addr1.address, utils.hexZeroPad("0x01", 32));
    await noticeBoard.connect(addr1).submit();
    await noticeBoard.scribble(
      slotNo,
      utils.hexZeroPad("0x8ac7230489e80000", 32)
    );
    await expect(
      BigNumber.from("10000000000000000000000000000").lt(
        await courseToken.balanceOf(addr1.address)
      )
    ).to.eq(true);

    // Attempt HitMeBabyOneMoreTime
    const ExploitHitMeBabyOneMoreTime = await ethers.getContractFactory(
      "ExploitHitMeBabyOneMoreTime"
    );
    const exploitHitMeBabyOneMoreTime =
      await ExploitHitMeBabyOneMoreTime.deploy();
    await exploitHitMeBabyOneMoreTime.deployed();
    await exploitHitMeBabyOneMoreTime.exploit(hitMeBabyOneMoreTime.address);
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("140000000000000000000")
    );

    // Attempt ImFeelingLucky
    const ExploitImFeelingLucky = await ethers.getContractFactory(
      "ExploitImFeelingLucky"
    );
    const exploitImFeelingLucky = await ExploitImFeelingLucky.deploy();
    for (let i = 0; i < 10; i += 1) {
      await exploitImFeelingLucky.exploit(imFeelingLucky.address);
    }
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("170000000000000000000")
    );

    // Attempt JiXiangKat
    const ExploitJiXiangKat = await ethers.getContractFactory(
      "ExploitJiXiangKat"
    );
    const exploitJiXiangKat = await ExploitJiXiangKat.deploy();
    await jiXiangKat.moneyMoneyMoney(exploitJiXiangKat.address);
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("190000000000000000000")
    );

    // Attempt Spendthrift
    const ExploitSpendthrift = await ethers.getContractFactory(
      "ExploitSpendthrift"
    );
    const exploitSpendthrift = await ExploitSpendthrift.deploy();
    await spendthrift.gimmeYourCard(exploitSpendthrift.address);
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("210000000000000000000")
    );

    // Attempt IRobot
    const ExploitIRobot = await ethers.getContractFactory("ExploitIRobot");
    const exploitIRobot = await ExploitIRobot.deploy();
    await exploitIRobot.exploit(iRobot.address);
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("230000000000000000000")
    );

    // Attempt MoneyLaunderer
    const ExploitMoneyLaunderer = await ethers.getContractFactory(
      "ExploitMoneyLaunderer"
    );
    const exploitMoneyLaunderer = await ExploitMoneyLaunderer.deploy();
    await moneyLaunderer.launder(exploitMoneyLaunderer.address, {
      value: utils.parseEther("0.01"),
    });
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("250000000000000000000")
    );

    // Attempt MathOlympiad
    const ExploitMathOlympiad = await ethers.getContractFactory(
      "ExploitMathOlympiad"
    );
    const exploitMathOlympiad = await ExploitMathOlympiad.deploy();
    await mathOlympiad.compete(exploitMathOlympiad.address);
    await expect(await courseToken.balanceOf(owner.address)).to.equal(
      BigNumber.from("270000000000000000000")
    );
  });
});
