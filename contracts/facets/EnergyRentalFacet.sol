//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.9;

contract EnergyRentalFacet{
    
    uint256 public _totalSupply;
    address owner;
    uint256 unitPricetoRentalEnergy = 100;


    struct EnergyDetails{
        uint256 energyAmount;
        uint rentalDuration;
    }

    mapping(address => EnergyDetails[]) private energyBorrowers;
    mapping(address=>uint256) private _balances;

    uint256 contractTrxBlc;

    event tokenMint(uint256);
    event unstakedTron(uint256);
    event energyAmount(uint256);
    event newUnit(uint256);

    constructor(){
        owner = msg.sender;
    }
    
    function setPriceUnit(uint256 unit) public {
        require(msg.sender==owner,"onlyowner can call function");
        unitPricetoRentalEnergy = unit;
        emit newUnit(unitPricetoRentalEnergy);
    }

    function _mint(address to,uint256 amount) internal {
       _balances[to] +=  amount;
       _totalSupply += amount;
    }
    
    function _burn(address to,uint256 amount) internal {
       _balances[to] -=  amount;
       _totalSupply -= amount;

    }

    function getEthBalance()public view returns(uint256){
        return contractTrxBlc;
    }


    //stake some tron to get Rewards
    function stakeTron(uint256 _amount) public payable returns(uint256 xa){        
        require(msg.value==_amount,'Insuffucient Amout');
        uint256 totalTrx = contractTrxBlc;
        uint256 totalShares = _totalSupply;

        if (totalShares == 0 || totalTrx == 0) {
            _mint(msg.sender, _amount);
            //freezebalancev2(msg.value,1);        
            contractTrxBlc = contractTrxBlc + msg.value;
            emit tokenMint(_amount);
            return _amount;    
            
        } else {
            
             uint256 what = ((_amount*totalShares)/(totalTrx));
            _mint(msg.sender, what);
             contractTrxBlc = contractTrxBlc + msg.value;
            //freezebalancev2(msg.value,1);
            emit tokenMint(what);
            return what;
        }
    }

    function unstakeTron(uint256 _share) public  {
        uint256 totalShares = _totalSupply;
        uint256 what = (_share * contractTrxBlc)/(totalShares);
        _burn(msg.sender, _share);
        payable(msg.sender).transfer(what);
        contractTrxBlc -= what;
        emit unstakedTron(what);
    }

    function rentEnergyFormula(uint tronAmount,uint256 rentalDuration) public  view returns(uint256 energyRentalAmount ){
        energyRentalAmount =  (tronAmount *1440) / (unitPricetoRentalEnergy *  rentalDuration); 
        return (energyRentalAmount);
    }

    function rentEnergy(uint tronAmount,uint256 rentalDuration) public payable returns(uint256 energyRentalAmount) {
       energyRentalAmount = rentEnergyFormula(tronAmount,rentalDuration);
       require(msg.value == tronAmount,"Insufficient amount");
       contractTrxBlc +=msg.value;
       EnergyDetails memory instance;
       rentalDuration = block.timestamp + rentalDuration;
       instance.energyAmount += energyRentalAmount;
       instance.rentalDuration += rentalDuration;
       energyBorrowers[msg.sender].push(instance);


       //uint256 delegatedTrons = energyRentalAmount * (1000000 / 59 );


       //freezebalancev2(energyRentalAmount, 1);
       //payable(msg.sender).delegateResource(energyRentalAmount, 1);
       
       emit energyAmount(energyRentalAmount);
       return energyRentalAmount;
    }

    function increaseRentalAmount(uint256 idx,uint256 amt) public payable {
        require(amt==msg.value,"Insufficient Amount");
        energyBorrowers[msg.sender][idx].energyAmount +=amt;
    }

    function increaseRentalDuration(uint256 idx,uint256 duration) public payable{
        energyBorrowers[msg.sender][idx].rentalDuration +=duration;
    }

    function balanceOf(address x) public view returns(uint256 amount){
        return _balances[x];
    }


    //pop all the elements of an array for energy borrower
    function endRent(address x,uint256 idx) public {
        require(msg.sender==owner,"only moderator can call the function");
        require(block.timestamp>energyBorrowers[x][idx].rentalDuration,"cant delegate before time");
        uint256 x = energyBorrowers[x][idx].energyAmount;
        // x.unDelegateResource(x);
    }

    function cleanup(address adr) public {
        require(msg.sender==owner,"only moderator can call the functions");
            energyBorrowers[adr].pop();        
    }


    function rentEnergyFormulaMins(uint tronAmount,uint256 rentalDuration) public  view returns(uint256 payTron ){
       uint256 energyRentalAmount;

       energyRentalAmount =  (tronAmount * 1440) / (unitPricetoRentalEnergy *  rentalDuration); 
       return (energyRentalAmount);

    }

    function rentEnergyMins(uint tronAmount,uint256 rentalDuration) public payable returns(uint256 energyRentalAmount) {
        
        energyRentalAmount = rentEnergyFormulaMins(tronAmount,rentalDuration);
       require(msg.value == tronAmount,"Insufficient amount");
       contractTrxBlc +=msg.value;
       EnergyDetails memory instance;

       rentalDuration = block.timestamp + rentalDuration;

       instance.energyAmount += energyRentalAmount;
       instance.rentalDuration += rentalDuration;

       energyBorrowers[msg.sender].push(instance);

        uint256 tronUnit = 1000000;
        uint256 tronDelegate =energyRentalAmount * ( tronUnit / 59 );


       //freezebalancev2(tronDelegate, 1);
       //payable(msg.sender).delegateResource(tronDelegate, 1);
       emit energyAmount(energyRentalAmount);
       return energyRentalAmount;
    }


}

    // function rentEnergyFormula(uint energyRentalAmount,uint256 rentalDuration) public  pure returns(uint256 payTron ){
    //     uint256 unitPricetoRentalEnergy = 100;
    //     //uint256 payTron = (1000000 / trxtoEnergy ) * energyRentalAmount ;
    //     payTron = energyRentalAmount * unitPricetoRentalEnergy *  rentalDuration;
    //     //uint256 Securitydeposit = (energyRentalAmount * unitPricetoRentalEnergy) + Liquidationfee;
    //     return (payTron);
    // }

    // function rentEnergy(uint energyRentalAmount,uint256 rentalDuration) public payable returns(uint256 paytrn) {
        
    //    (uint256 payTron) = rentEnergyFormula(energyRentalAmount,rentalDuration);
    //    require(msg.value >= payTron,"Insufficient amount");
       
    //    contractTrxBlc +=msg.value;

    //    energyBorrowers[msg.sender].energyAmount += energyRentalAmount;
    //    energyBorrowers[msg.sender].rentalDuration += rentalDuration;
    //    //freezebalancev2(energyRentalAmount, 1);
    //    //payable(msg.sender).delegateResource(energyRentalAmount, 1);
    //    return payTron;
    // }