# Decentralized system for medical prescriptions


Project made for a college course. It consists of decentralizing the medical prescription system, each prescription is be an ERC721 token.

## How to use it

To test this project I recomend using https://remix.ethereum.org/. To run this project you should follow the following steps:

* Deploy prescription.sol
* Deploy hospital.sol and give it the prescription.sol contract address
* Use the functions from hospital.sol to deploy the other contracts
* Deploy the other contracts at the address that the deploy function from hospital.sol gave to them

To transfer a prescription, you must approve the prescription.sol address from the owner addres.