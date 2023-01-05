// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// @title Contracte pels pacients
// @author Lluis Sánchez Calm
// @notice S'encarrega de gestionar totes les accions que poden utilitzar els pacients


import "./hospital.sol";
import "./prescription.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";

contract PharmacyContract is Ownable{

    ////////////////////////////////
    //      CONSTRUCTOR
    ////////////////////////////////

    PrescriptionNFT prescription;
    Hospital hospital;

    constructor(address _prescriptionAddress, address _hospitalAddress) public {
        prescription = PrescriptionNFT(_prescriptionAddress);
        hospital = Hospital(_hospitalAddress);

    }

    ////////////////////////////////
    //      MODIFIER
    ////////////////////////////////

    modifier onlyPharmacy (address _address){
        require(hospital.isPharmacy(_address));
        _;
    }


    ////////////////////////////////
    //      FUNCTIONS
    ////////////////////////////////

    // @param id de la recepta
    // @dev funció per eliminar la recepta una vegada li han donat a la farmacia
    function deletePrescription(uint _tokenID) public onlyPharmacy(msg.sender) {
        prescription.burnNFT(_tokenID);
    }

}