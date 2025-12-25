// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Task_09 {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // События: индексируемый идентификатор пользователя и неиндексируемое сообщение
    event UserAdded(uint256 indexed userId, string message);
    event UserRemoved(uint256 indexed userId, string message);

    // Хранилище пользователей: простое наличие по id
    mapping(uint256 => bool) public users;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function addUser(uint256 _userId) external onlyOwner {
        require(!users[_userId], "User already exists");
        users[_userId] = true;
        emit UserAdded(_userId, "User has been added");
    }

    function removeUser(uint256 _userId) external onlyOwner {
        require(users[_userId], "User does not exist");
        users[_userId] = false;
        emit UserRemoved(_userId, "User has been removed");
    }

    // Пример 3: Работа с фиксированным массивом байтов
    // Фиксированный массив bytes1[4] — массив из 4 байтов фиксированной длины
    // Функция возвращает сумму всех байтов (приведённых к uint8)
    function getFixedByteArraySum(bytes1[4] memory _data) public pure returns (uint8) {
        uint8 sum = 0;
        for (uint8 i = 0; i < _data.length; i++) {
            sum += uint8(_data[i]);
        }
        return sum;
    }
}
