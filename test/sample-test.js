const { expect } = require("chai");
const { ethers, network } = require("hardhat");
const { Signer } = require("ethers");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");
const { AbiCoder } = require("ethers/lib/utils");
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

  let _identity,key,signer1,newkey,signer2,identityIssuer,implementationAuthority,_identityProxy,proxy,claimHolder,claimIssuer,claimIssuerContract;

  beforeEach(async()=>{
    [owner,identityIssuer,claimIssuer,signer1,signer2] =await ethers.getSigners();

    // let abiCoder = ethers.utils.defaultAbiCoder;
    // // key = abiCoder.encode(abi.foobar.inputs, values);

    //  key = ethers.utils.keccak256(ethers.utils.AbiCoder( "address" , identityIssuer.address ));
    const key = web3.utils.keccak256(web3.eth.abi.encodeParameter('address', identityIssuer.address));
     const newKey = web3.utils.keccak256(web3.eth.abi.encodeParameter('address', signer1.address));
    const Identity = await ethers.getContractFactory("identity");
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


      it("by default the identity should have a management key when deployed",async()=>{
        const check = await claimHolder.keyHasPurpose(key, 1);
        expect(check).to.be.equal(true);
      })
      
      it("purpose can be addto the new address(key) if the msg.sender the owner of the claim holder",async()=>{
        const check = await claimHolder.connect(identityIssuer).addKey(newkey,3,1);
        expect(check).to.equal(true);

      })

      it("when the msg.sender dosnt have the management key revert ",async ()=>{
        expect(claimHolder.connect(signer1).addKey(newkey,1,1)).to.be.revertedWith(" Permissions: Sender does not have management key");
      })
      it("it should fail if the purpose is provided again",async()=>{
        expect(claimHolder.connect(identityIssuer).addKey(key,1,1)).to.be.revertedWith("Conflict: Key already has purpose");

      })

      it("revert if key doesnt exist",async()=>{
        //the newkey is the hash of the signer1.addres where that address has no identity contract soo there will be no key
        expect(claimHolder.connect(identityIssuer).removeKey(newKey,1)).to.be.revertedWith("NonExisting: Key isn't registered");
      });

      it("when the purpose of the claim holder is removed he cant add the key",async()=>{
         await claimHolder.connect(identityIssuer).removeKey(key,1);
         expect(claimHolder.connect(identityIssuer).addKey(key,2,1)).to.be.revertedWith("Permissions: Sender does not have management key");

      })
      it("remove key will return true if the given purpose exist for the key and the msg.sender should have management key with him",async()=>{
        let check = await claimHolder.connect(identityIssuer).removeKey(key,1);
        expect(check).to.equal(true);s
      })
       it("reverts when the address called has no ma")
      it("addClaim will revert when the msg.sender got no claim key ==3",async()=>{
        await claimHolder.connect(claimHolder).addKey(key,3,1);
        await claimHolder.connect(claimHolder).addClaim(1,1,claimIssuerContract.address, '0x24', '0x12', '');


      })

      it(" remove the claimId where it is added initially",async()=>{
        // bytes32 claimId = keccak256(abi.encode(_issuer, _topic));
        const claimId = web3.utils.keccak256(web3.eth.abi.encodeParameters(['address', 'uint'],[ claimIssuerContract.address, 1]));
        const tx = await claimHolder.connect(identityIssuer).removeClaim(claimId);
        expect(tx).to.equal(true);
      })
      it("gets reverted if the msg.sender doesnt have the msnagement key (dount))",async()=>{
        const claimId = web3.utils.keccak256(web3.eth.abi.encodeParameters(['address', 'uint'], [claimIssuerContract.address, 1]));
        await claimHolder.connect(signer1).removeClaim(claimId).to.be.revertedWith("Permissions: Sender does not have claim signer key");
      })











})



