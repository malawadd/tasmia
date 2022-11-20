// SPDX-License-Identifier: MIT

import "./TasmiaRequest.sol";

pragma solidity ^0.8.15;

contract TasmiaFactory {
    //Init the array of deployed contract addresses
    address[] public deployedData;
    mapping(address => address[]) public studentsData;

    function createData(
        string memory name,
        string memory description,
        string memory imageHash,
        uint256 price,
        string[] memory moduleNames,
        string[] memory moduleDescriptions,
        string[] memory materialHashes,
        string[] memory questionHashes
    ) public {
        TasmiaRequest newData = new TasmiaRequest(
            msg.sender,
            name,
            description,
            imageHash,
            price,
            moduleNames,
            moduleDescriptions,
            materialHashes,
            questionHashes
        );
        deployedData.push(address(newData));
    }

    function joinData(address DataAddress) public payable {
        TasmiaRequest Data = TasmiaRequest(payable(DataAddress));
        studentsData[msg.sender].push(DataAddress);
        Data.enroll{value: msg.value}(msg.sender);
    }

    function returnEnrolledData() public view returns (address[] memory) {
        address[] memory Data = studentsData[msg.sender];
        return (Data);
    }

    function getDeployedData() public view returns (address[] memory) {
        return deployedData;
    }
}
