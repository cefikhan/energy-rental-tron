
// /* global ethers task */
// require("@nomiclabs/hardhat-etherscan");
// require('@nomiclabs/hardhat-waffle')

// // This is a sample Hardhat task. To learn how to create your own go to
// // https://hardhat.org/guides/create-task.html
// task('accounts', 'Prints the list of accounts', async () => {
//   const accounts = await ethers.getSigners()

//   for (const account of accounts) {
//     console.log(account.address)
//   }
// })

// // You need to export an object to set up your config
// // Go to https://hardhat.org/config/ to learn more

// /**
//  * @type import('hardhat/config').HardhatUserConfig
//  */
// module.exports = {
//   solidity: '0.8.17',
//   networks: {
//     goerli: {
//         url: "YOUR_QUICKNODE_HTTP_ENDPOINT",
//         accounts: ["YOUR_PRIVATE_KEY"]
//     }
//     },
//     etherscan: {
//         // Your API key for Etherscan
//         // Obtain one at https://etherscan.io/
//         apiKey: "YOUR_ETHERSCAN_API_KEY"
//     },
//   settings: {
//     optimizer: {
//       enabled: true,
//       runs: 200
//     }
//   }
// }



require('@nomiclabs/hardhat-waffle')

module.exports = {
  solidity: '0.8.9',
  settings: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
}
