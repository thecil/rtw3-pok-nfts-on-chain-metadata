import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import 'dotenv/config';
import 'hardhat-deploy';
import '@nomiclabs/hardhat-etherscan';

const { ALCHEMY_RPC, MNEMONIC, POLYGONSCAN_API_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: {
    compilers: [{
      version: '0.8.10'
    },
    ],
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      live: false,
      saveDeployments: true,
      tags: ["localhost"]
    },
    mumbai: {
      url: ALCHEMY_RPC,
      chainId: 80001,
      accounts: { mnemonic: MNEMONIC },
      live: true,
      saveDeployments: true,
      tags: ["mumbai"]
    }
  },
  namedAccounts: {
    deployer: {
      default: 0,
      "mumbai": '0x32F0a4Db8350a0882241623A50587e048e11a126'
    },
    tipper: {
      default: 1,
      "mumbai": '0x9B5416219dc491519cdf4523C0c2Ed290b780A9f'
    },
    tipper2: {
      default: 2,
      "mumbai": '0x9B5416219dc491519cdf4523C0c2Ed290b780A9f'
    },
    tipper3: {
      default: 3,
      "mumbai": '0x9B5416219dc491519cdf4523C0c2Ed290b780A9f'
    },
  },
  etherscan: {
    apiKey: POLYGONSCAN_API_KEY
  }
};

export default config;