require("@nomiclabs/hardhat-waffle");
require("hardhat-watcher");
require("dotenv").config();
const { types } = require("hardhat/config");
const deployer = require("./scripts/deployer");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

task("deploy", "Deploy the contracts", async (args) => {
  await deployer(args);
})
  .addOptionalParam(
    "contract",
    "CourseContract address to deploy to (reuse existing contract)",
    "",
    types.string
  )
  .addOptionalParam("skip", "Number of levels to skip", 0, types.int);

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.5.17",
  networks: {
    hardhat: {},
    rinkeby: {
      url: process.env.ENDPOINT_RINKEBY,
      accounts: [process.env.ACCOUNT_1],
    },
  },
  watcher: {
    test: {
      tasks: ["compile", "test"],
      files: ["./contracts", "./test"],
    },
  },
};
