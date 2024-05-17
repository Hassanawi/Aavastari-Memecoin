const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const { env } = require('../../.env');
require('dotenv').config(env);


const OWNER = Public_key;
const ContractAddress = Contract_Address;

module.exports = buildModule("LockModule",  (m) => {
    const owner = m.getParameter("owner", OWNER);
    const nft_contactAddress = m.getParameter("nft_contractAddress", ContractAddress);

  const test =  m.contract("AVASTARI",[nft_contactAddress]);
  return { test };
});
