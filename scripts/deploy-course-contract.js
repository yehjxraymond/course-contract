// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const { deployAllLevels } = require("../src/deployLevels");

async function main() {
  console.log(arguments);
  const CourseContract = await hre.ethers.getContractFactory("CourseContract");
  const courseContract = await CourseContract.deploy("Course Token", "CTK");

  await courseContract.deployed();

  console.log("courseContract deployed to:", courseContract.address);

  const tokenAddress = await courseContract.courseToken();
  const courseToken = await hre.ethers.getContractAt(
    "CourseToken",
    tokenAddress
  );

  console.log("courseToken deployed to:", courseToken.address);

  await deployAllLevels(courseContract, hre.ethers, true);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
