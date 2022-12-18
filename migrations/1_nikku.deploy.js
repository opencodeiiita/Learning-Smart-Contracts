const Nikku = artifacts.require("Nikku");

module.exports= async function(deployer){
    await deployer.deploy(Nikku,2000);
}