// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Task_11 {
    address public owner;

    // Статус контракта
    enum Status { Open, Closed }
    Status public status = Status.Open;

    // 1. Сумма всех переводов на контракт
    uint256 public totalUserDeposits;

    // Целевая сумма для закрытия контракта (пример)
    uint256 public targetAmount;

    // Балансы вкладчиков
    mapping(address => uint256) public deposits;

    // События
    event Deposited(address indexed user, uint256 amount, uint256 totalDeposits);
    event Withdrawn(address indexed user, uint256 amount, uint256 totalDeposits);
    event Closed(uint256 totalDeposits);

    constructor(uint256 _targetAmount) {
        owner = msg.sender;
        targetAmount = _targetAmount;
    }

    // 2. Модификатор onlyOwner()
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // 3. Модификатор whenClosed()
    modifier whenClosed() {
        require(status == Status.Closed, "Contract is not closed");
        _;
    }

    modifier whenOpen() {
        require(status == Status.Open, "Contract is closed");
        _;
    }

    // 4. Доработанная функция deposit()
    function deposit() external payable whenOpen {
        require(msg.value > 0, "Deposit must be > 0");

        // учитываем адрес вкладчика и сумму
        deposits[msg.sender] += msg.value;

        // учитываем общую сумму баланса контракта
        totalUserDeposits += msg.value;

        emit Deposited(msg.sender, msg.value, totalUserDeposits);

        // при достижении или превышении цели — закрываем контракт
        if (totalUserDeposits >= targetAmount) {
            status = Status.Closed;
            emit Closed(totalUserDeposits);
        }
    }

    // 5. Доработанная функция withdraw()
    // пример: после закрытия контракта владелец выводит все собранные средства
    function withdraw() external onlyOwner whenClosed {
        uint256 amount = address(this).balance;
        require(amount > 0, "Nothing to withdraw");

        // общий баланс уменьшается
        totalUserDeposits = 0;

        // переводим средства владельцу
        (bool sent, ) = owner.call{value: amount}("");
        require(sent, "Withdraw failed");

        emit Withdrawn(owner, amount, totalUserDeposits);
    }
}
