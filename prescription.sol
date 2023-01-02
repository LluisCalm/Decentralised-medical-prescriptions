// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// @title NFT que defineix les receptes dins el projecte de digitalitzar el sistema de receptres sanitàries 
// @author Lluis Sánchez Calm
// Openzeppelin imports

import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";

contract PrescriptionNFT is ERC721 {

    ////////////////////////////////
    //      CONSTRUCTOR
    ////////////////////////////////
    constructor () ERC721("PrescriptionNFT","IMP"){} // IMP = International medicine prescription


    ////////////////////////////////
    //  STRUCT AND ARRAY
    ////////////////////////////////

    struct Prescription {
        address doctorAddress;
        address patientAddress;
        string expirationDate;
        string IUM;
        uint id;
        string medicineName;
        string state;
    }

    // Array per a les prescripcions
    Prescription[] public prescriptions;


    ////////////////////////////////
    //      FUNCTIONS
    ////////////////////////////////

    function mintPrescription(address _patientAddress, uint _id, address _doctorAddress, string memory _expirationDate, string memory _IUM, string memory _medicineName) public {
        prescriptions.push(Prescription(_doctorAddress, _patientAddress, _expirationDate, _IUM, _id, _medicineName, "dispensed"));
        _safeMint(_patientAddress, _id);
    }

    function burnNFT(uint _tokenID) public {
        _burn(_tokenID);
    }

    function changeState(uint _tokenID, string memory _state) public {
        prescriptions[_tokenID].state = _state;
    }

    function getPrescriptionState(uint _tokenID) public returns (string memory){
        return prescriptions[_tokenID].state;
    }

    function transferPrescription(uint _tokenID, address _pharmacyAddress) external {
        transferFrom(msg.sender,_pharmacyAddress, _tokenID);
    }
}