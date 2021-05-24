const { expect } = require("chai");
const { BigNumber } = require("ethers");

describe("CourseContract", () => {
  it("should work as expected", async () => {
    const [owner, addr1] = await ethers.getSigners();

    const CourseContract = await ethers.getContractFactory("CourseContract");
    const courseContract = await CourseContract.deploy("Course Token", "CTK");

    await courseContract.deployed();

    const tokenAddress = await courseContract.courseToken();
    const courseToken = await ethers.getContractAt("CourseToken", tokenAddress);

    const HelloWorld = await ethers.getContractFactory("HelloWorld");
    const helloWorld = await HelloWorld.deploy(courseContract.address);

    await helloWorld.deployed();

    await courseContract.addLevel(helloWorld.address);

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
  });
});
