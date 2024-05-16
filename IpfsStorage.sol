// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract Upload {
    
    mapping(address => string[]) private userFiles;
    mapping(address => mapping(address => bool)) private sharedFiles;
    
    modifier onlyOwnerAccess(address _user) {
        require(msg.sender == _user,"You are not authorized");
        _;
    }
    
    event FileShared(address indexed from, address indexed to, string ipfsHash);
    function uploadFile(address _user, string memory _ipfsHash) external {
        userFiles[_user].push(_ipfsHash);
    }
    
    function shareFile(address _recipient, string memory _ipfsHash) external {
        require(userFiles[msg.sender].length > 0, "You don't have any files to share.");
        require(!sharedFiles[msg.sender][_recipient], "File already shared with this address.");
        
        sharedFiles[msg.sender][_recipient] = true;
        emit FileShared(msg.sender, _recipient, _ipfsHash);
    }

    function viewFiles(address _user) external view onlyOwnerAccess(_user) returns (string[] memory) {
        return userFiles[_user];
    }
}
