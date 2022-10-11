const { expect } = require("chai");
const { ethers, network } = require("hardhat");
const { Signer } = require("ethers");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");


describe("testing",()=>{
  // let identityRegistry,identityRegistryStorage,tokenName,
  let claimTopicsRegistry;
  let identityRegistry;
  let identityRegistryStorage;
  let trustedIssuersRegistry;
  let claimIssuerContract;
  let compliance;
  let token;
  let _token;
  let agentManager;
  let defaultCompliance;
  let tokenName;
  let tokenSymbol;
  let tokenDecimals;
  let tokenOnchainID;
  let proxy;
  let implementation;
  let signer1;
  let signer2;
  let owner;
  let claimIssuer;
  let signerKey;
  let claimTopics=[1,7,3];


  beforeEach(async ()=>{
    [owner,signer1,signer2,tokenAgent] = await ethers.getSigners();

    const TrustedIssuersRegistry = await ethers.getContractFactory("TrustedIssuersRegistry");
    trustedIssuersRegistry = await TrustedIssuersRegistry.deploy();
    await trustedIssuersRegistry.deployed();

    const ClaimTopicsRegistry = await ethers.getContractFactory("claimTopicsRegistry");
    claimTopicsRegistry = await ClaimTopicsRegistry.deploy();
    await claimIssuerContract.deployed();


    const IdentityRegistryStorage = await ethers.getContractFactory("IdentityRegistryStorage");
    identityRegistryStorage = await IdentityRegistryStorage.deploy();
    await identityRegistryStorage.deployed();

     
    //above three deployed contracts are included in the identity contract

    const IdentityRegistry = await ethers.getContractFactory("IdentityRegistry");
    identityRegistry = await IdentityRegistry.deploy(trustedIssuersRegistry.address,claimTopicsRegistry.address,identityRegistryStorage.address);
    await identityRegistry.deployed();

    const Compliance = await ethers.getContractFactory("DefaultCompliance");
    compliance = await Compliance.deploy();
    tokenName = 'TREXToken';
    tokenSymbol = 'TREX';
    tokenDecimals = '0';
    
    const Token = await ethers.getContractFactory("Token");
    _token = await Token.deploy(identityRegistry.address,);


    const Implementation = await ethers.getContractFactory("ImplementationAuthority");
    implementation = await Implementation.deploy(token.address);

    const Proxy = await ethers.getContractFactory("TokenProxy");
    proxy = await Proxy.deploy(identityRegistry.address,compliance.address,tokenName,tokenSymbol,tokenDecimals,_onChainId);


    token = _token.attach(proxy.address);

    await identityRegistryStorage.bindIdentityRegistry(identityRegistry.address);
    await token.addAgentOnTokenContract(tokenAgent);

    await claimTopicsRegistry.addClaimTopic(7);

     signerKey = web3.utils.keccak256(web3.eth.abi.encodeParameter('address', signer.address));

   //get the claimIssuer contract from the on chainId and the address claimIssure is the getting approved as the claimIssuer
    const ClaimIssuerContract = await ethers.getContractFactory("ClaimIssuer");
    
    claimIssuerContract =  await ClaimIssuerContract.connect(claimIssuer).deploy(claimIssuer);
    await claimIssuerContract.addKey(signerKey.address,3,1);
    await trustedIssuersRegistry.addTrustedIssuer(claimIssuerContract.address,claimTopics);
    
    






    
















    


    












  })

});

