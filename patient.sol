// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// @title Contracte pels pacients
// @author Lluis Sánchez Calm
// @notice S'encarrega de gestionar totes les accions que poden utilitzar els pacients


import "./hospital.sol";
import "./prescription.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";

contract PatientContract is Ownable{

    ////////////////////////////////
    //      CONSTRUCTOR
    ////////////////////////////////

    Hospital hospital;
    PrescriptionNFT prescription;
    address prescriptionAddress;

    uint prescriptionFee = 0.001 ether;

    // @param la direccio de l'adreça de l'hospital i la del token ERC721
    constructor(address _hospitalAddress, address _prescriptionAddress) public {
        hospital = Hospital(_hospitalAddress);
        prescription = PrescriptionNFT(_prescriptionAddress);
        prescriptionAddress = _prescriptionAddress;
    }

    ////////////////////////////////
    //      MODIFIERS
    ////////////////////////////////

    // @dev comprova si una direcció pertany a una farmàcia
    modifier toPharmacy (address _address) {
        require(hospital.isPharmacy(_address), "Destinatary not a pharmacy");
        _;
    }


    ////////////////////////////////
    //      FUNCTIONS
    ////////////////////////////////

    // @dev envia la recepta a la farmàcia
    // @param direcció de la farmàcia i identificador del token
    // @notice s'ha de donar permís al contracte del token per gestionar aquesta recepta
    function sendPrescription (address _pharmacyAddress, uint _tokenID) public toPharmacy(_pharmacyAddress) payable {
        require(msg.value == prescriptionFee);
        prescription.transferPrescription(msg.sender, _tokenID, _pharmacyAddress);
        prescription.changeState(_tokenID, "used");
    }

    // @dev Per modificar el cost d'un medicament
    // @param uint el valor en eth
    function setPrescriptionFee(uint _fee) external onlyOwner {
        prescriptionFee = _fee;
  }
    
}