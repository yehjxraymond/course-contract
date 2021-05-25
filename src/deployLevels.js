const LEVEL_CONTRACTS = ["HelloWorld", "ReadAndWrite", "MyBlockNumber"];

const deployAllLevels = async (courseContract, ethers, log) => {
  const levels = [];
  for (let i = 0; i < LEVEL_CONTRACTS.length; i += 1) {
    const level = LEVEL_CONTRACTS[i];
    const LevelContract = await ethers.getContractFactory(level);
    const levelContract = await LevelContract.deploy(courseContract.address);
    await levelContract.deployed();
    if (log) console.log(`${level} deployed to ${levelContract.address}`);
    await courseContract.addLevel(levelContract.address);
    if (log) console.log(`CourseContract added level: ${level}`);
    levels.push(levelContract);
  }
  return levels;
};

module.exports = {
  LEVEL_CONTRACTS,
  deployAllLevels,
};
