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

    constructor(address _prescriptionAddress) public {
        prescription = PrescriptionNFT(_prescriptionAddress);

    }

    ////////////////////////////////
    //      FUNCTIONS
    ////////////////////////////////

    // @param id de la recepta
    // @dev funció per eliminar la recepta una vegada li han donat a la farmacia
    function deletePrescription(uint _tokenID) public onlyOwner{
        prescription.burnNFT(_tokenID);
    }

    // @param addres to withdraw
    function withdraw(address payable _destination) public onlyOwner {
        _destination.transfer(address(this).balance);
  }

}