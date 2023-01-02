// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// @title Contracte que defineix l'hospital i tot el que pot fer dins el projecte de digitalitzar el sistema de receptres sanitàries 
// @author Lluis Sánchez Calm

import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";
import "./doctor.sol";
import "./prescription.sol";
import "./patient.sol";
import "./pharmacy.sol";


contract Hospital is Ownable {

    ////////////////////////////////
    //      VARIABLES
    ////////////////////////////////

    // Una per a cada un dels contractes implicats i una referència al contracte
    // de les receptes mèdiques
    address hospitalContractAddress;
    address doctorsContractAddress;
    address patientsContractAddress;
    address pharmaciesContractAddress;
    address prescriptionContractAddress;
    PrescriptionNFT prescriptionNFT;

    uint private id;

    ////////////////////////////////
    //      CONSTRUCTOR
    ////////////////////////////////

    // @dev al fer el deploy del contracte de metges passem per paràmetre
    // la direcció del token per poder cridar a la funció mint
    constructor(address _address) public {
        hospitalContractAddress = address(this);
        prescriptionContractAddress = _address;
        prescriptionNFT = PrescriptionNFT(_address);
        id = 0; // Inicialitzem la variable id a 0 per comptar les receptes
    }

    ////////////////////////////////
    //          STRUCTS
    ////////////////////////////////

    // Struct que defineix els metges
    struct Doctor {
        string name;
        address doctor_address;
        uint membership_number;
        bool isValue;
    }

    // Struct pels pacients
    struct Patient {
        string name;
        address patientAdress;
    }

    // Struct per a les farmàcies
    struct Pharmacy {
        string name;
        address pharmacy_name;
        uint membership_number;
    }

    ////////////////////////////////
    //          GETTERS
    ////////////////////////////////

    // Enlloc de fer aixo afegir una característica isValue al doctor i mirar aquell valor
    function isDoctor (address _address) public returns(bool){
        return doctors_list[_address];
    }  

    function isPatient (address _address )public returns(bool){
        return patients_list[_address];
    }

    function isPharmacy (address _address) public returns (bool){
        return pharmacy_list[_address];
    }

    ////////////////////////////////
    //  MAPPINGS AND ARRAYS
    ////////////////////////////////

    // Array per als metges
    Doctor[] public doctors;
    // Arrays per als pacients
    Patient[] public patients;
    // Array per a les farmacies
    Pharmacy[] public pharmacies;

    // Mapping per als metges
    mapping (address => bool) public doctors_list;
    // Mapping per als pacients
    mapping (address => bool) public patients_list;
    // Mapping per a les farmacies
    mapping (address => bool) public pharmacy_list;

    // Mapping per obtneir el nom a partir de la direcció 
    mapping(address => string) public addressToDoctor;
    mapping(address => string) public addressToPatient;
    mapping(address => string) public addressToPharmacy;

    // Mapping per obtenir el metge que ha creat una recepta
    mapping(uint => address) public prescriptionToDoctor;

    ////////////////////////////////
    //          EVENTS
    ////////////////////////////////

    // Events to notice when a doctor/patient/pharmacy is created
    event doctorCreated(address _doctorAddress, string name);
    event patientCreated(address _patientAddress, string name);
    event pharmacyCreated(address _pharmacyAddress, string name);

    // Event per avisar de la creació d'una nova recepta
    event prescriptionCreated(uint id, address doctorAddress, address patientAddres);


    ////////////////////////////////
    //          MODIFIERS
    ////////////////////////////////

    modifier onlyFromDoctorContract (address _address) {
        require(_address == doctorsContractAddress);
        _;
    }

    modifier onlyFromPatientContract(address _address) {
        require(_address == patientsContractAddress);
        _;
    }


    ////////////////////////////////
    //          FUNCTIONS
    ////////////////////////////////

    function createDoctor(string memory _name, address _address, uint _membership_number) public onlyOwner {
        doctors.push(Doctor(_name, _address, _membership_number, true));
        addressToDoctor[_address] = _name;
        emit doctorCreated(_address, _name);
    }

    function createPatient(string memory _name, address _address) public onlyOwner{
        patients.push(Patient(_name, _address));
        patients_list[_address] = true;
        addressToPatient[_address] = _name;
        emit patientCreated(_address, _name);
    }

    function createPharmacy(string memory _name, address _address, uint _membership_number) public onlyOwner {
        pharmacies.push(Pharmacy(_name, _address, _membership_number));
        pharmacy_list[_address] = true;
        addressToPharmacy[_address] = _name;
        emit pharmacyCreated(_address, _name);
    }

    function createPrescription(address _patientAddress, address _doctorAddress, string memory _expirationDate, string memory _IUM, string memory _medicineName) public onlyFromDoctorContract(msg.sender){
        prescriptionNFT.mintPrescription(_patientAddress, id, _doctorAddress, _expirationDate, _IUM, _medicineName);
        prescriptionToDoctor[id] = _doctorAddress;
        emit prescriptionCreated(id, _doctorAddress, _patientAddress);
        id++;
    }

    function deletePrescription(uint _tokenID) public onlyOwner{
        prescriptionNFT.burnNFT(_tokenID);
    }

    ////////////////////////////////
    //  DEPLOY OTHER CONTRACTS
    ////////////////////////////////

    function deployDoctorContract() public onlyOwner returns (address){
        doctorsContractAddress = address (new DoctorContract(hospitalContractAddress));
        return doctorsContractAddress;
    }

    function deployPatientContract() public onlyOwner returns (address){
        patientsContractAddress = address (new PatientContract(hospitalContractAddress, prescriptionContractAddress));
        return patientsContractAddress;
    }

    function deployPharmacyContract() public onlyOwner returns (address){
        pharmaciesContractAddress = address (new PharmacyContract(hospitalContractAddress, prescriptionContractAddress));
        return pharmaciesContractAddress;
    }

}