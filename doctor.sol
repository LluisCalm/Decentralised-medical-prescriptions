// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// @title Contracte pels metges
// @author Lluis Sánchez Calm
// @notice S'encarrega de gestionar totes les accions que poden utilitzar els metges


import "./hospital.sol";
import "./prescription.sol";

contract DoctorContract {

    Hospital hospital;

    // @param la direccio de l'adreça de l'hospital
    constructor(address _hospitalAddress) public {
        hospital = Hospital(_hospitalAddress);
    }

    // @dev Funció per crear una recepta que només poden executar els metges
    // @param direccio del pacient, fecha de caducitat, IUM i nom del medicament
    function createPrescription(address _patientAddress, string memory _expirationDate, string memory _IUM, string memory _medicineName) public  onlyDoctor(msg.sender) toPatient(_patientAddress) isIUMcorrect(_IUM){
        hospital.createPrescription(_patientAddress, msg.sender, _expirationDate, _IUM, _medicineName);
    }

    ////////////////////////////////
    //      Modifiers
    ////////////////////////////////


    // @dev comprova si una direccio pertany a un metge
    modifier onlyDoctor (address _address) {
        require(hospital.isDoctor(_address), "Not doctor");
        _;
    }

    // @dev comprova si una direccio pertany a un pacient
    modifier toPatient (address _address) {
        require(hospital.isPatient(_address), "Destinatary is not a patient");
        _;
    }

    // @dev comprova si el Valor de l'IUM té la longitud correcta
    modifier isIUMcorrect(string memory _IUM){
        require(bytes(_IUM).length==13, "IUM must be size 13");
        _;
    }
    
}