const Token = artifacts.require("Token");

module.exports = async function (deployer) {
  await deployer.deploy(Token, "NFT Game", "NFTG");
  let token = await Token.deployed();
  await token.mint(100, 200, 100000); // token id is 0
  let pet = await token.getTokenDetails(0);
  console.log(pet);
};
