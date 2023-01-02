// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// @title  Contracte que defineix les farmàcies i tot el que poden fer dins el projecte de digitalitzar el sistema de receptres sanitàries 
// @author Lluis Sánchez Calm

import "./hospital.sol";
import "./prescription.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";

contract PharmacyContract is Ownable{

    ////////////////////////////////
    //      CONSTRUCTOR
    ////////////////////////////////

    Hospital hospital;
    address hospitalContractAddress;
    PrescriptionNFT prescription;

    constructor(address _hospitalAddress, address _prescriptionAddress) public {
        hospitalContractAddress = _hospitalAddress;
        hospital = Hospital(hospitalContractAddress);
        prescription = PrescriptionNFT(_prescriptionAddress);

    }

    ////////////////////////////////
    //      MODIFIERS
    ////////////////////////////////

    modifier toHospital(address _address){
        require(_address == hospitalContractAddress);
        _;
    }

    ////////////////////////////////
    //      FUNCTIONS
    ////////////////////////////////

    // @param id de la recepta
    // @dev funció per eliminar la recepta una vegada li han donat a la farmacia
    function deletePrescription(uint _tokenID) public onlyOwner{
        prescription.burnNFT(_tokenID);
    }
}