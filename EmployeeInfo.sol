// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmployeeInfo {
    address public admin;

    struct Employee {
        string aadharCard;
        string name;
        uint age;
        address walletAddress;
        string username;
        string password;
    }

    mapping(address => Employee) public employees;
    mapping(string => address) public usernameToAddress;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action");
        _;
    }

    modifier onlyEmployee() {
        require(msg.sender == admin || keccak256(bytes(employees[msg.sender].password)) != keccak256(bytes("")), "Unauthorized access");
        _;
    }

    function addEmployee(
        string memory _aadharCard,
        string memory _name,
        uint _age,
        address _walletAddress,
        string memory _username,
        string memory _password
    ) public onlyAdmin {
        employees[_walletAddress] = Employee(_aadharCard, _name, _age, _walletAddress, _username, _password);
        usernameToAddress[_username] = _walletAddress;
    }

    function viewEmployeeInfo(string memory _username, string memory _password) public view onlyEmployee returns (string memory, string memory, uint, address) {
        address employeeAddress = usernameToAddress[_username];
        require(keccak256(bytes(employees[employeeAddress].password)) == keccak256(bytes(_password)), "Invalid username or password");
        Employee storage employee = employees[employeeAddress];
        return (employee.aadharCard, employee.name, employee.age, employee.walletAddress);
    }

    function setUsernameAndPassword(string memory _username, string memory _password) public {
        employees[msg.sender].username = _username;
        employees[msg.sender].password = _password;
        usernameToAddress[_username] = msg.sender;
    }
}
