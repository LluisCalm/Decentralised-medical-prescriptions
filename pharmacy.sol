// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// @title  Contracte que defineix les farmàcies i tot el que poden fer dins el projecte de digitalitzar el sistema de receptres sanitàries 
// @author Lluis Sánchez Calm

import "./hospital.sol";
import "./prescription.sol";

contract PharmacyContract {

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

    function sendPrescriptionToHospital (uint _tokenID) public {
        prescription.transferFrom(msg.sender, hospitalContractAddress, _tokenID);
    }
}