 const { expect } = require('chai')

/* global describe it before ethers */

const {
    getSelectors,
    FacetCutAction,
    removeSelectors,
    findAddressPositionInFacets
  } = require('../scripts/libraries/diamond.js')
  
  const { deployDiamond } = require('../scripts/deploy.js')
  
  const { assert } = require('chai')



describe('DiamondTest', async function () {
    let diamondAddress
    let diamondCutFacet
    let diamondLoupeFacet
    let ownershipFacet
    let energyRentalFacet
    let tx
    let receipt
    let result
    const addresses = []

    before(async function () {
        diamondAddress = await deployDiamond()
        diamondCutFacet = await ethers.getContractAt('DiamondCutFacet', diamondAddress)
        diamondLoupeFacet = await ethers.getContractAt('DiamondLoupeFacet', diamondAddress)
        ownershipFacet = await ethers.getContractAt('OwnershipFacet', diamondAddress)
        energyRentalFacet = await ethers.getContractAt('EnergyRentalFacet',diamondAddress)
      })

      it('should have three facets -- call to facetAddresses function', async () => {
        for (const address of await diamondLoupeFacet.facetAddresses()) {
          addresses.push(address)
        }
    
        assert.equal(addresses.length, 4)
      })

      it('facets should have the right function selectors -- call to facetFunctionSelectors function', async () => {
        let selectors = getSelectors(diamondCutFacet)
    
        result = await diamondLoupeFacet.facetFunctionSelectors(addresses[0])
        assert.sameMembers(result, selectors)

        selectors = getSelectors(diamondLoupeFacet)
        result = await diamondLoupeFacet.facetFunctionSelectors(addresses[1])
        assert.sameMembers(result, selectors)
        
        selectors = getSelectors(ownershipFacet)
        result = await diamondLoupeFacet.facetFunctionSelectors(addresses[2])

        selectors = getSelectors(energyRentalFacet)
        result = await diamondLoupeFacet.facetFunctionSelectors(addresses[3])

        assert.sameMembers(result, selectors)
      
    })


  it('selectors should be associated to facets correctly -- multiple calls to facetAddress function', async () => {
    assert.equal(
      addresses[0],
      await diamondLoupeFacet.facetAddress('0x1f931c1c')
    )
    assert.equal(
      addresses[1],
      await diamondLoupeFacet.facetAddress('0xcdffacc6')
    )
    assert.equal(
      addresses[1],
      await diamondLoupeFacet.facetAddress('0x01ffc9a7')
    )
    assert.equal(
      addresses[2],
      await diamondLoupeFacet.facetAddress('0xf2fde38b')
    )
  })


  it('should call stakeTron to stake 1000000 sun tron to mint 1000000 sun xtrx as expected',async function(){


    const accounts = await ethers.getSigners()
    const contractOwner = accounts[0]

    const energyrentalFacet = await ethers.getContractAt('EnergyRentalFacet',diamondAddress)

    const options = {value: 1000000}

    let tx = await energyrentalFacet.stakeTron(1000000,options)
    let receipt =await tx.wait(1);
    
    expect(receipt.events[0].args.toString()).to.equal("1000000");
    

    const blc =await energyrentalFacet.balanceOf(contractOwner.address);
    expect(blc).to.equal(1000000);

})










})