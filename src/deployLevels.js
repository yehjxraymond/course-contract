const LEVEL_CONTRACTS = [
  "HelloWorld",
  "ReadAndWrite",
  "MyBlockNumber",
  "WishingWell",
  "DirtyDirtySecret",
  "SelectMeNot",
  "FindMyABI",
  "HashCrack",
  "HeSaysSheSays",
  "NoticeBoard",
  "HitMeBabyOneMoreTime",
  "ImFeelingLucky",
  "JiXiangKat",
  "Spendthrift",
  "IRobot",
  "MoneyLaunderer",
  "MathOlympiad",
  "ConnectTheDot",
  "CrystalBall",
  "KittyBreeder",
];

const deployAllLevels = async ({ courseContract, ethers, log, skip = 0 }) => {
  const levels = [];
  for (let i = skip; i < LEVEL_CONTRACTS.length; i += 1) {
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
