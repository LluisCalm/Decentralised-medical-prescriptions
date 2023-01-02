// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// @title Contracte que defineix els pacients i tot el que poden fer dins el projecte de digitalitzar el sistema de receptres sanitàries 
// @author Lluis Sánchez Calm

import "./hospital.sol";
import "./prescription.sol";

contract PatientContract {

    ////////////////////////////////
    //      CONSTRUCTOR
    ////////////////////////////////

    Hospital hospital;
    PrescriptionNFT prescription;
    address prescriptionAddress;

    constructor(address _hospitalAddress, address _prescriptionAddress) public {
        hospital = Hospital(_hospitalAddress);
        prescription = PrescriptionNFT(_prescriptionAddress);
        prescriptionAddress = _prescriptionAddress;

    }

    ////////////////////////////////
    //      MODIFIERS
    ////////////////////////////////

    modifier toPharmacy (address _address) {
        require(hospital.isPharmacy(_address), "Destinatary not a pharmacy");
        _;
    }

    modifier ifAddressAvailable (address _address){
        require(!hospital.isPatient(_address));
        _;
    }

    ////////////////////////////////
    //      FUNCTIONS
    ////////////////////////////////

    function sendPrescription (address _pharmacyAddress, uint _tokenID) public toPharmacy(_pharmacyAddress){
        prescription.transferPrescription(_tokenID, _pharmacyAddress);
        prescription.changeState(_tokenID, "used");
    }
    
}