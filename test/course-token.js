const { expect } = require("chai");

describe("CourseToken", () => {
  it("should work as expected", async () => {
    const [owner, addr1] = await ethers.getSigners();

    const CourseToken = await ethers.getContractFactory("CourseToken");
    const courseToken = await CourseToken.deploy("Course Token", "CTK", 18);

    await courseToken.deployed();

    // Should look like token
    expect(await courseToken.symbol()).to.equal("CTK");
    expect(await courseToken.decimals()).to.equal(18);
    expect(await courseToken.name()).to.equal("Course Token");

    // Token minter can mint tokens
    await courseToken.mint(addr1.address, "10000");
    expect(await courseToken.balanceOf(addr1.address)).to.equal("10000");

    // Non-minters cannot mint tokens
    await expect(
      courseToken.connect(addr1).mint(addr1.address, "10000")
    ).to.be.revertedWith("MinterRole: caller does not have the Minter role");

    // Token owners may not transfer token
    await expect(
      courseToken.connect(addr1).transfer(owner.address, 100)
    ).to.be.revertedWith("Transfer is not allowed on the token");
  });
});
