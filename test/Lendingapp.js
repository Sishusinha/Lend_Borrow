const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");


const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const tokens = (n) => {
  return ethers.parseUnits(n.toString(), "ether");
};



describe("LendingPlatform", function () {
  let lendingPlatform;
  let owner;
  let borrower;
  let lender;
  let loanId;

  const MIN_INTEREST_RATE = 1;
  const MAX_INTEREST_RATE = 10;
  const AMOUNT = tokens(4); // 1 ETH
  const INTEREST_RATE = 5; // 5%
  const DURATION = 2; // 7 days

  beforeEach(async function () {
    [owner, borrower, lender] = await ethers.getSigners();

    const LendingPlatform = await ethers.getContractFactory("LendingPlatform");
    lendingPlatform = await LendingPlatform.deploy();


    // Borrower creates a loan
    transaction = await lendingPlatform.connect(borrower).createLoan(AMOUNT, INTEREST_RATE, DURATION);
    await transaction.wait();
    loanId = 0; // Assuming this is the first loan created
    
    
    
  });
  it("Should create a loan", async function () {

    const loanInfo = await lendingPlatform.getLoanInfo(0);
    expect(loanInfo.amount).to.equal(AMOUNT);
    expect(loanInfo.interest).to.equal(INTEREST_RATE);
    expect(loanInfo.duration).to.equal(DURATION);
    expect(loanInfo.active).to.equal(true);
    expect(loanInfo.repaid).to.equal(false);
  });
  

  it("Should fund a loan", async function () {

    const trac= await lendingPlatform.connect(lender).fundLoan(0, AMOUNT,{value:tokens(4)});
    await trac.wait();

    const loanInfo = await lendingPlatform.getLoanInfo(loanId);
    expect(loanInfo.lender).to.equal(lender.address);
    expect(loanInfo.active).to.equal(true);
  });

  it("Should repay a loan", async function () {
    await lendingPlatform.connect(lender).fundLoan(loanId, AMOUNT,{value:tokens(4)});
    await lendingPlatform.connect(borrower).repayLoan(loanId,{value:tokens(4.2)});

    const loanInfo = await lendingPlatform.getLoanInfo(loanId);
    expect(loanInfo.repaid).to.equal(true);
    expect(loanInfo.active).to.equal(false);
  });
});
