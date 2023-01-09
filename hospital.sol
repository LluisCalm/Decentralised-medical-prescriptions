// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// @title Contracte per l'hospital
// @author Lluis Sánchez Calm
// @notice S'encarrega de gestionar totes les accions del gestor del sistema (l'hospital)


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
    PatientContract patientContract;
    PrescriptionNFT prescriptionNFT;

    uint private id;

    ////////////////////////////////
    //      CONSTRUCTOR
    ////////////////////////////////

    // @param direcció del contracte ERC721
    constructor(address _address) public {
        hospitalContractAddress = address(this);
        prescriptionContractAddress = _address;
        prescriptionNFT = PrescriptionNFT(_address);
        id = 0; // Inicialitzem la variable id a 0 per comptar les receptes
    }

    ////////////////////////////////
    //          STRUCTS
    ////////////////////////////////

    // @dev Struct que defineix els metges
    struct Doctor {
        string name;
        address doctor_address;
        uint membership_number;
        bool isValue;
    }

    // @dev Struct pels pacients
    struct Patient {
        string name;
        address patientAdress;
    }

    // @dev Struct per a les farmàcies
    struct Pharmacy {
        string name;
        address pharmacy_name;
        uint membership_number;
    }

    ////////////////////////////////
    //          GETTERS
    ////////////////////////////////

    // @dev comprova si una direcció pertany a un doctor
    function isDoctor (address _address) public returns(bool){
        return doctors_list[_address];
    }  

    // @dev comprova si una direcció pertany a un pacient
    function isPatient (address _address )public returns(bool){
        return patients_list[_address];
    }

    // @dev comprova si una direcció pertany a una farmàcia
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

    // @dev modificador que comprova que la direcció sigui la del contracte de doctors
    modifier onlyFromDoctorContract (address _address) {
        require(_address == doctorsContractAddress);
        _;
    }

    // @dev modificador que comprova que la direcció sigui la del contracte de pacients
    modifier onlyFromPatientContract(address _address) {
        require(_address == patientsContractAddress);
        _;
    }


    ////////////////////////////////
    //          FUNCTIONS
    ////////////////////////////////

    // @param nom, direccio, nombre de col·legiat
    // @dev funció per crear un doctor 
    function createDoctor(string memory _name, address _address, uint _membership_number) public onlyOwner {
        doctors.push(Doctor(_name, _address, _membership_number, true));
        doctors_list[_address] = true;
        addressToDoctor[_address] = _name;
        emit doctorCreated(_address, _name);
    }

    // @param nom i direcció
    // @dev funció per crear un pacient
    function createPatient(string memory _name, address _address) public onlyOwner{
        patients.push(Patient(_name, _address));
        patients_list[_address] = true;
        addressToPatient[_address] = _name;
        emit patientCreated(_address, _name);
    }

    // @param nom, direcció i nombre de col·legiat
    // @dev funció per crear una farmàcia
    function createPharmacy(string memory _name, address _address, uint _membership_number) public onlyOwner {
        pharmacies.push(Pharmacy(_name, _address, _membership_number));
        pharmacy_list[_address] = true;
        addressToPharmacy[_address] = _name;
        emit pharmacyCreated(_address, _name);
    }

    // @param adreça del pacient i del doctor, data de caducitat, IUM i nom
    // @dev funció per crear una recepta
    function createPrescription(address _patientAddress, address _doctorAddress, string memory _expirationDate, string memory _IUM, string memory _medicineName) public onlyFromDoctorContract(msg.sender){
        prescriptionNFT.mintPrescription(_patientAddress, id, _doctorAddress, _expirationDate, _IUM, _medicineName);
        prescriptionToDoctor[id] = _doctorAddress;
        emit prescriptionCreated(id, _doctorAddress, _patientAddress);
        id++;
    }

    // @param new fee
    // @dev funció per actualitzar la tasa dels medicaments
    function setPrescriptionFee(uint _fee) public onlyOwner{
        patientContract.setPrescriptionFee(_fee);
    }

    ////////////////////////////////
    //  DEPLOY OTHER CONTRACTS
    ////////////////////////////////

    function deployDoctorContract() public onlyOwner returns (address){
        doctorsContractAddress = address (new DoctorContract(hospitalContractAddress));
        return doctorsContractAddress;
    }

    function deployPatientContract() public onlyOwner returns (address){
        patientContract = new PatientContract(hospitalContractAddress, prescriptionContractAddress);
        patientsContractAddress = address (patientContract);
        return patientsContractAddress;
    }

    function deployPharmacyContract() public onlyOwner returns (address){
        pharmaciesContractAddress = address (new PharmacyContract(prescriptionContractAddress, hospitalContractAddress));
        return pharmaciesContractAddress;
    }

}