// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";


contract dBank {
    // Assign Token contract to variable
    Token private token;

    // Add mappings
    mapping(address => uint) public etherBalanceOf;
    mapping(address => uint) public depositStart;
    mapping(address => bool) public isDeposited;

    // Add events
    event EmitDeposit(address indexed user, uint etherAmount, uint timeStart);
    event EmitWithdraw(address indexed user, uint etherAmount, uint depositTime, uint interest);

    // Pass as constructor argument deployed Token contract
    constructor(Token _token) public {
        //assign token deployed contract to variable
        token = _token;
    }

    function deposit() public payable {
        // Check if msg.sender didn't already deposited funds
        require(isDeposited[msg.sender] == false, "Error, deposit already active");
        // Check if msg.value is >= than 0.01 ETH
        require(msg.value >= 1e16, "Error, deposit must be >= 0.01 ETH");

        // Increase msg.sender ether deposit balance
        etherBalanceOf[msg.sender] = etherBalanceOf[msg.sender] + msg.value;

        // Start msg.sender hodling time
        depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;

        // Set msg.sender deposit status to true
        isDeposited[msg.sender] = true;

        // Emit Deposit event
        emit EmitDeposit(msg.sender, msg.value, block.timestamp);
    }

    function withdraw() public {
        // Check if msg.sender deposit status is true
        require(isDeposited[msg.sender] == true, "Error, no previous deposit");
        // Assign msg.sender ether deposit balance to variable for event
        uint userBalance = etherBalanceOf[msg.sender];

        // Check user's hodl time
        uint depositTime = block.timestamp - depositStart[msg.sender];

        // Calc interest per second
        uint interestPerSecond = 31668017 * (etherBalanceOf[msg.sender] / 1e16);

        // Calc accrued interest
        uint interest = interestPerSecond * depositTime;

        // Send eth to user
        msg.sender.transfer(etherBalanceOf[msg.sender]);
        // Send interest in tokens to user
        token.mint(msg.sender, interest);

        // Reset depositer data
        depositStart[msg.sender] = 0;
        etherBalanceOf[msg.sender] = 0;
        isDeposited[msg.sender] = false;

        // Emit event
        emit EmitWithdraw(msg.sender, userBalance, depositTime, interest);
    }

    function borrow() public payable {
        //check if collateral is >= than 0.01 ETH
        //check if user doesn't have active loan

        //add msg.value to ether collateral

        //calc tokens amount to mint, 50% of msg.value

        //mint&send tokens to user

        //activate borrower's loan status

        //emit event
    }

    function payOff() public {
        //check if loan is active
        //transfer tokens from user back to the contract

        //calc fee

        //send user's collateral minus fee

        //reset borrower's data

        //emit event
    }
}
