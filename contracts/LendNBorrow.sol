//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract LendingPlatform {
    // The minimum and maximum interest rate in percentage that can be set for a loan
    uint256 public constant MIN_INTEREST_RATE = 1;
    uint256 public constant MAX_INTEREST_RATE = 10;
    struct Loan {
        uint256 amount;
        uint256 interest;
        uint256 duration;
        uint256 repaymentAmount;
        uint256 fundingDeadline;
        address borrower;
        address payable lender;
        bool active;
        bool repaid;
    }
    mapping(uint256 => Loan) public loans;
    mapping(address => uint256) public credit_score;
    uint256 public loanCount;
    event LoanCreated(
        uint256 loanId,
        uint256 amount,
        uint256 interest,
        uint256 duration,
        uint256 fundingDeadline,
        address borrower,
        address lender
    );
    event LoanFunded(uint256 loanId, address funder, uint256 amount);
    event LoanRepaid(uint256 loanId, uint256 amount);
    modifier onlyActiveLoan(uint256 _loanId) {
        require(loans[_loanId].active, "Loan is not active");
        _;
    }
    modifier onlyBorrower(uint256 _loanId) {
        require(
            msg.sender == loans[_loanId].borrower,
            "Only the borrower can perform this action"
        );
        _;
    }

    function createLoan(
        uint256 _amount,
        uint256 _interest,
        uint256 _duration
    ) public {
        require(
            _interest >= MIN_INTEREST_RATE && _interest <= MAX_INTEREST_RATE,
            "Interest rate must be between MIN_INTEREST_RATE and MAX_INTEREST_RATE"
        );
        require(_duration > 0, "Loan duration must be greater than 0");
        uint256 _repaymentAmount = _amount + (_amount * _interest) / 100;
        uint256 _fundingDeadline = block.timestamp + (1 days);
        uint256 loanId = loanCount++;
        Loan storage loan = loans[loanId];
        loan.amount = _amount;
        loan.interest = _interest;
        loan.duration = _duration;
        loan.repaymentAmount = _repaymentAmount;
        loan.fundingDeadline = _fundingDeadline;
        loan.borrower = msg.sender;
        loan.lender = payable(address(0));
        loan.active = true;
        loan.repaid = false;
        credit_score[msg.sender] -= 0;
        emit LoanCreated(
            loanId,
            _amount,
            _interest,
            _duration,
            _fundingDeadline,
            msg.sender,
            address(0)
        );
    }

    function fundLoan(
        uint256 _loanId,
        uint256 amt
    ) external payable onlyActiveLoan(_loanId) {
        Loan storage loan = loans[_loanId];
        require(
            msg.sender != loan.borrower,
            "Borrower cannot fund their own loan"
        );
        require(loan.amount == amt, "not enough");
        require(
            block.timestamp <= loan.fundingDeadline,
            "Loan funding deadline has passed"
        );
        payable(loan.borrower).transfer(amt);
        loan.lender = payable(msg.sender);
        loan.active = true;
        credit_score[msg.sender] += amt;
        emit LoanFunded(_loanId, msg.sender, msg.value);
    }

    function repayLoan(
        uint256 _loanId
    ) external payable onlyActiveLoan(_loanId) onlyBorrower(_loanId) {
        require(
            msg.value == loans[_loanId].repaymentAmount,
            "Incorrect repayment amount"
        );
        loans[_loanId].lender.transfer(msg.value);
        credit_score[msg.sender] += msg.value;
        loans[_loanId].repaid = true;
        loans[_loanId].active = false;
        emit LoanRepaid(_loanId, msg.value);
    }

    function getLoanInfo(
        uint256 _loanId
    )
        external
        view
        returns (
            uint256 amount,
            uint256 interest,
            uint256 duration,
            uint256 repaymentAmount,
            uint256 fundingDeadline,
            address borrower,
            address lender,
            bool active,
            bool repaid
        )
    {
        Loan storage loan = loans[_loanId];
        return (
            loan.amount,
            loan.interest,
            loan.duration,
            loan.repaymentAmount,
            loan.fundingDeadline,
            loan.borrower,
            loan.lender,
            loan.active,
            loan.repaid
        );
    }

    function balanceCheck(address _person) public view returns (uint256) {
        return _person.balance;
    }
}
