# Lend_Borrow
A platform that let users Lend and Borrow the app

Project Description


➢ Major Area: Lending And Borrowing

➢ Title: Managing personal finance using Blockchain

➢ Dapp name: Loan-Dapp

➢ Clients: Lenders, Borrowers(Requestors)


Prerequisites

Before setting up and running the Lending Platform DApp locally, ensure you have the following prerequisites:

Node.js and npm installed on your machine.            

A development Ethereum wallet (e.g., MetaMask) and some test Ether for interacting with the DApp.

Hardhat framework installed globally.

Steps to Deploy in Local Hardhat Environment:
1. Make a directory
2. Install hardhat using npx install hardhat
3. Open the directory and there paste the smart contract in the contract folder by making a
.sol file
4. Now in the Test folder make a file of .js and paste the test there
5. Run npx hardhat test to check if the code is working or not
6. Open a command terminal and start npx hardhat node
7. Now go in the directory that you made and go to deploy.js file and copy paste the code 
from github uploaded deploy.js
8. Run the script on local network using command:
npx hardhat run --network localhost scripts/deploy.js
9. Now you will see your smart contract is deployed on the local blockchain of Hardhat
10. Note the deployed address as it is shown on terminal after deployment
11. From the artifact file in the directory to go contract and then to the .json file and copy the 
ABIs
12. Run the react code provided and put the Abis and deployment address ready, also install 
the metamask in the chrome extension
13. Now connect the Frontend with the React app
14. You can see the address of Connected Account on the screen


Technologies and Frameworks Used
The Lending Platform DApp is built using the following technologies and frameworks:

Solidity: The smart contract language used to define the core logic of the lending platform.
Hardhat: A development framework for Ethereum that simplifies contract compilation, migration, and testing.
React: A JavaScript library for building user interfaces. It provides the front-end of the DApp.
Web3.js: A JavaScript library that allows interaction with the Ethereum blockchain from web applications.
MetaMask: A browser extension wallet used for Ethereum wallet integration.
npm: The package manager for JavaScript used to manage project dependencies.
