const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const { env } = require('../../.env');
require('dotenv').config(env);


const OWNER = Public_key;

module.exports = buildModule("LockModule",  (m) => {
  const owner = m.getParameter("owner", OWNER);
  const test =  m.contract("AvastariNFT");

  return { test };
});
