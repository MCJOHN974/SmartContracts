// SPDX-License-Identifier: MIT
// EIP-20 implementation
// Copyright (c) 2022 Viktar Makouski 

pragma solidity ^0.8.7;


contract EIP20 {
    mapping(address => uint256) private balances_;
    mapping(address => mapping(address => uint256)) private permissions_;
    uint256 total_supply_;

    constructor(address init_owner) {
        total_supply_ = 2 ** 255;
        balances_[init_owner] = total_supply_;
    }
    
    function name() public view returns (string memory) {
        return "GAPEEV";
    }

    function symbol() public view returns (string memory) {
        return "GPV";
    }

    function decimals() public view returns (uint8) {
        return 1;
    }

    function totalSupply() public view returns (uint256) {
        return total_supply_;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances_[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        emit Transfer(msg.sender, _to, _value);
        require(balances_[msg.sender] >= _value, "Not enough tokens");
        balances_[msg.sender] -= _value;
        balances_[_to] += _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        emit Transfer(_from, _to, _value);
        // require(permissions_[_from][_to].keyIndex > 0, "No permissions");
        require(permissions_[_from][msg.sender] >= _value, "Not enought permissions");
        require(balances_[_from] >= _value, "Not enought balance");
        balances_[_from] -= _value;
        balances_[_to] += _value;
        permissions_[_from][msg.sender] -= _value;
        if (permissions_[_from][msg.sender] == 0) {
            delete(permissions_[_from][msg.sender]);
        }
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        permissions_[msg.sender][_spender] += _value;
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return permissions_[_owner][_spender];
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}