pragma solidity 0.6.10;

// SPDX-License-Identifier: GPL-3.0-only

import "../interface/RocketStorageInterface.sol";

/// @title Base settings / modifiers for each contract in Rocket Pool
/// @author David Rugendyke

abstract contract RocketBase {


    // Version of the contract
    uint8 public version;

    // The main storage contract where primary persistant storage is maintained
    RocketStorageInterface rocketStorage = RocketStorageInterface(0);


    /**
    * @dev Throws if called by any sender that doesn't match a Rocket Pool network contract
    */
    modifier onlyLatestNetworkContract() {
        require(getAddress(keccak256(abi.encodePacked("contract.address", msg.sender))) != address(0x0), "Invalid or outdated network contract");
        _;
    }


    /**
    * @dev Throws if called by any sender that doesn't match one of the supplied contract or is the latest version of that contract
    */
    modifier onlyLatestContract(string memory _contractName, address _contractAddress) {
        require(_contractAddress == getAddress(keccak256(abi.encodePacked("contract.name", _contractName))), "Invalid or outdated contract");
        _;
    }


    /**
    * @dev Throws if called by any sender that isn't a registered node
    */
    modifier onlyRegisteredNode(address _nodeAddress) {
        require(getBool(keccak256(abi.encodePacked("node.exists", _nodeAddress))), "Invalid node");
        _;
    }


    /**
    * @dev Throws if called by any sender that isn't a trusted node
    */
    modifier onlyTrustedNode(address _nodeAddress) {
        require(getBool(keccak256(abi.encodePacked("node.trusted", _nodeAddress))), "Invalid trusted node");
        _;
    }


    /**
    * @dev Throws if called by any sender that isn't a registered minipool
    */
    modifier onlyRegisteredMinipool(address _minipoolAddress) {
        require(getBool(keccak256(abi.encodePacked("minipool.exists", _minipoolAddress))), "Invalid minipool");
        _;
    }


    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(roleHas("owner", msg.sender), "Account is not the owner");
        _;
    }


    /**
    * @dev Modifier to scope access to admins
    */
    modifier onlyAdmin() {
        require(roleHas("admin", msg.sender), "Account is not an admin");
        _;
    }


    /**
    * @dev Modifier to scope access to admins
    */
    modifier onlySuperUser() {
        require(roleHas("owner", msg.sender) || roleHas("admin", msg.sender), "Account is not a super user");
        _;
    }


    /**
    * @dev Reverts if the address doesn't have this role
    */
    modifier onlyRole(string memory _role) {
        require(roleHas(_role, msg.sender), "Account does not match the specified role");
        _;
    }


    /// @dev Set the main Rocket Storage address
    constructor(address _rocketStorageAddress) public {
        // Update the contract address
        rocketStorage = RocketStorageInterface(_rocketStorageAddress);
    }


    /// @dev Get the address of a network contract
    function getContractAddress(string memory _contractName) internal view returns (address) {
        // Get the current contract address
        address contractAddress = getAddress(keccak256(abi.encodePacked("contract.name", _contractName)));
        // Check it
        require(contractAddress != address(0x0), "Contract not found");
        // Return
        return contractAddress;
    }


    /// @dev Storage get methods
    function getAddress(bytes32 _key) internal view returns (address) { return rocketStorage.getAddress(_key); }
    function getUint(bytes32 _key) internal view returns (uint) { return rocketStorage.getUint(_key); }
    function getString(bytes32 _key) internal view returns (string memory) { return rocketStorage.getString(_key); }
    function getBytes(bytes32 _key) internal view returns (bytes memory) { return rocketStorage.getBytes(_key); }
    function getBool(bytes32 _key) internal view returns (bool) { return rocketStorage.getBool(_key); }
    function getInt(bytes32 _key) internal view returns (int) { return rocketStorage.getInt(_key); }
    function getBytes32(bytes32 _key) internal view returns (bytes32) { return rocketStorage.getBytes32(_key); }
    function getAddressS(string memory _key) internal view returns (address) { return rocketStorage.getAddress(keccak256(abi.encodePacked(_key))); }
    function getUintS(string memory _key) internal view returns (uint) { return rocketStorage.getUint(keccak256(abi.encodePacked(_key))); }
    function getStringS(string memory _key) internal view returns (string memory) { return rocketStorage.getString(keccak256(abi.encodePacked(_key))); }
    function getBytesS(string memory _key) internal view returns (bytes memory) { return rocketStorage.getBytes(keccak256(abi.encodePacked(_key))); }
    function getBoolS(string memory _key) internal view returns (bool) { return rocketStorage.getBool(keccak256(abi.encodePacked(_key))); }
    function getIntS(string memory _key) internal view returns (int) { return rocketStorage.getInt(keccak256(abi.encodePacked(_key))); }
    function getBytes32S(string memory _key) internal view returns (bytes32) { return rocketStorage.getBytes32(keccak256(abi.encodePacked(_key))); }

    /// @dev Storage set methods
    function setAddress(bytes32 _key, address _value) internal { rocketStorage.setAddress(_key, _value); }
    function setUint(bytes32 _key, uint _value) internal { rocketStorage.setUint(_key, _value); }
    function setString(bytes32 _key, string memory _value) internal { rocketStorage.setString(_key, _value); }
    function setBytes(bytes32 _key, bytes memory _value) internal { rocketStorage.setBytes(_key, _value); }
    function setBool(bytes32 _key, bool _value) internal { rocketStorage.setBool(_key, _value); }
    function setInt(bytes32 _key, int _value) internal { rocketStorage.setInt(_key, _value); }
    function setBytes32(bytes32 _key, bytes32 _value) internal { rocketStorage.setBytes32(_key, _value); }
    function setAddressS(string memory _key, address _value) internal { rocketStorage.setAddress(keccak256(abi.encodePacked(_key)), _value); }
    function setUintS(string memory _key, uint _value) internal { rocketStorage.setUint(keccak256(abi.encodePacked(_key)), _value); }
    function setStringS(string memory _key, string memory _value) internal { rocketStorage.setString(keccak256(abi.encodePacked(_key)), _value); }
    function setBytesS(string memory _key, bytes memory _value) internal { rocketStorage.setBytes(keccak256(abi.encodePacked(_key)), _value); }
    function setBoolS(string memory _key, bool _value) internal { rocketStorage.setBool(keccak256(abi.encodePacked(_key)), _value); }
    function setIntS(string memory _key, int _value) internal { rocketStorage.setInt(keccak256(abi.encodePacked(_key)), _value); }
    function setBytes32S(string memory _key, bytes32 _value) internal { rocketStorage.setBytes32(keccak256(abi.encodePacked(_key)), _value); }

    /// @dev Storage delete methods
    function deleteAddress(bytes32 _key) internal { rocketStorage.deleteAddress(_key); }
    function deleteUint(bytes32 _key) internal { rocketStorage.deleteUint(_key); }
    function deleteString(bytes32 _key) internal { rocketStorage.deleteString(_key); }
    function deleteBytes(bytes32 _key) internal { rocketStorage.deleteBytes(_key); }
    function deleteBool(bytes32 _key) internal { rocketStorage.deleteBool(_key); }
    function deleteInt(bytes32 _key) internal { rocketStorage.deleteInt(_key); }
    function deleteBytes32(bytes32 _key) internal { rocketStorage.deleteBytes32(_key); }
    function deleteAddressS(string memory _key) internal { rocketStorage.deleteAddress(keccak256(abi.encodePacked(_key))); }
    function deleteUintS(string memory _key) internal { rocketStorage.deleteUint(keccak256(abi.encodePacked(_key))); }
    function deleteStringS(string memory _key) internal { rocketStorage.deleteString(keccak256(abi.encodePacked(_key))); }
    function deleteBytesS(string memory _key) internal { rocketStorage.deleteBytes(keccak256(abi.encodePacked(_key))); }
    function deleteBoolS(string memory _key) internal { rocketStorage.deleteBool(keccak256(abi.encodePacked(_key))); }
    function deleteIntS(string memory _key) internal { rocketStorage.deleteInt(keccak256(abi.encodePacked(_key))); }
    function deleteBytes32S(string memory _key) internal { rocketStorage.deleteBytes32(keccak256(abi.encodePacked(_key))); }


    /**
    * @dev Check if an address has this role
    */
    function roleHas(string memory _role, address _address) internal view returns (bool) {
        return getBool(keccak256(abi.encodePacked("access.role", _role, _address)));
    }


}
