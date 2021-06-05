const { deployAllLevels } = require("../src/deployLevels");

const deployer = async ({ contract = "", skip = 0 }) => {
  const CourseContract = await ethers.getContractFactory("CourseContract");
  let courseContract;
  if (contract) {
    courseContract = await CourseContract.attach(contract);
    console.log("courseContract connected to:", courseContract.address);
  } else {
    courseContract = await CourseContract.deploy("Course Token", "CTK");
    await courseContract.deployed();
    console.log("courseContract deployed to:", courseContract.address);
  }

  const tokenAddress = await courseContract.courseToken();
  const courseToken = await ethers.getContractAt("CourseToken", tokenAddress);

  console.log("courseToken deployed to:", courseToken.address);

  await deployAllLevels({ courseContract, ethers, log: true, skip });
};

module.exports = deployer;
