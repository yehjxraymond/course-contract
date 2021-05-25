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

    const [helloWorld, readAndWrite, myBlockNumber, wishingWell] =
      await deployAllLevels(courseContract, ethers, false);

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
  });
});
