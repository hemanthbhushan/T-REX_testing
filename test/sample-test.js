const { expect } = require("chai");
const { ethers, network } = require("hardhat");
const { Signer } = require("ethers");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");
// const{IdentityProxy } = require("@onchain-id/solidity/contracts/IdentityProxy.sol");
// const{ImplementationAuthority } = require("@onchain-id/solidity/contracts/ImplementationAuthority.sol");
// const{ClaimIssuer} = require("@onchain-id/solidity/contracts/ClaimIssuer.sol")

// describe("testing",()=>{
//   // let identityRegistry,identityRegistryStorage,tokenName,
//   let claimTopicsRegistry;
//   let identityRegistry;
//   let identityRegistryStorage;
//   let trustedIssuersRegistry;
//   let claimIssuerContract;
//   let compliance;
//   let token;
//   let _token;
//   let agentManager;
//   let defaultCompliance;
//   let tokenName;
//   let tokenSymbol;
//   let tokenDecimals;
//   let tokenOnchainID;
//   let proxy;
//   let implementation;
//   let signer1;
//   let signer2;
//   let owner;
//   let claimIssuer;
//   let signerKey;
//   let claimTopics=[1,7,3];


//   beforeEach(async ()=>{
//     [owner,signer1,signer2,tokenAgent] = await ethers.getSigners();

//     const TrustedIssuersRegistry = await ethers.getContractFactory("TrustedIssuersRegistry");
//     trustedIssuersRegistry = await TrustedIssuersRegistry.deploy();
//     await trustedIssuersRegistry.deployed();

//     const ClaimTopicsRegistry = await ethers.getContractFactory("claimTopicsRegistry");
//     claimTopicsRegistry = await ClaimTopicsRegistry.deploy();
//     await claimIssuerContract.deployed();


//     const IdentityRegistryStorage = await ethers.getContractFactory("IdentityRegistryStorage");
//     identityRegistryStorage = await IdentityRegistryStorage.deploy();
//     await identityRegistryStorage.deployed();

     
//     //above three deployed contracts are included in the identity contract

//     const IdentityRegistry = await ethers.getContractFactory("IdentityRegistry");
//     identityRegistry = await IdentityRegistry.deploy(trustedIssuersRegistry.address,claimTopicsRegistry.address,identityRegistryStorage.address);
//     await identityRegistry.deployed();

//     const Compliance = await ethers.getContractFactory("DefaultCompliance");
//     compliance = await Compliance.deploy();
//     tokenName = 'TREXToken';
//     tokenSymbol = 'TREX';
//     tokenDecimals = '0';
    
//     const Token = await ethers.getContractFactory("Token");
//     _token = await Token.deploy(identityRegistry.address,);


//     const Implementation = await ethers.getContractFactory("ImplementationAuthority");
//     implementation = await Implementation.deploy(token.address);

//     const Proxy = await ethers.getContractFactory("TokenProxy");
//     proxy = await Proxy.deploy(identityRegistry.address,compliance.address,tokenName,tokenSymbol,tokenDecimals,_onChainId);


//     token = _token.attach(proxy.address);

//     await identityRegistryStorage.bindIdentityRegistry(identityRegistry.address);
//     await token.addAgentOnTokenContract(tokenAgent);

//     await claimTopicsRegistry.addClaimTopic(7);

//      signerKey = web3.utils.keccak256(web3.eth.abi.encodeParameter('address', signer.address));

//    //get the claimIssuer contract from the on chainId and the address claimIssure is the getting approved as the claimIssuer
//     const ClaimIssuerContract = await ethers.getContractFactory("ClaimIssuer");
    
//     claimIssuerContract =  await ClaimIssuerContract.connect(claimIssuer).deploy(claimIssuer);
//     await claimIssuerContract.addKey(signerKey.address,3,1);
//     await trustedIssuersRegistry.addTrustedIssuer(claimIssuerContract.address,claimTopics);
    
    
//for identity contract

describe("test for the identity contract",()=>{

  let _identity,identityIssuer,implementationAuthority,_identityProxy,proxy,claimHolder,claimIssuer,claimIssuerContract;

  beforeEach(async()=>{
    [owner,identityIssuer,claimIssuer] =await ethers.getSigners();

    const Identity = await ethers.getContractFactory("identity",owner);
     _identity  = await Identity.deploy(identityIssuer.address,true);

     const _ImplementationAuthority = await ethers.getContractFactory("ImplementationAuthority");
     implementationAuthority = await _ImplementationAuthority.deploy(_identity.address);

     const _IdentityProxy = await ethers.getContractFactory("IdentityProxy");

     _identityProxy = await _IdentityProxy.deploy(implementationAuthority.address,identityIssuer.address);
     //claim holder is nothing but the proxy of the identity contract

     claimHolder =  _identity.attach(_identityProxy.address);

     const _claimIssuer = await ethers.getContractFactory("ClaimIssuer");
     claimIssuerContract = await _claimIssuer.connect(claimIssuer).deploy(claimIssuer);
      
    //the addclaim can be added by the claimholder contract or the msg.sender with the claimIssuer key =3
      await claimHolder.connect(claimHolder).addClaim(1, 1, claimIssuerContract.address, '0x24', '0x12', 'tokenyyyy');
      

      // await claimHolder.connect(claimIssuerContract).addClaim(1, 1, claimIssuerContract.address, '0x24', '0x12', 'tokenyyyy');

      
      
  })
})



