// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ILUCRTokenCore {
    function mint(address to, uint256 value) external;
    function totalSupply() external view returns (uint256);
}

contract LUCRMintEngine {
    ILUCRTokenCore public lucr;
    address public governance;
    uint256 public maxSupply;

    event MintRequested(address indexed to, uint256 value);
    event MintExecuted(address indexed to, uint256 value);

    modifier onlyGovernance() {
        require(msg.sender == governance, "Not governance");
        _;
    }

    constructor(address _lucr, uint256 _maxSupply) {
        lucr = ILUCRTokenCore(_lucr);
        governance = msg.sender;
        maxSupply = _maxSupply;
    }

    function mintTo(address to, uint256 value) external onlyGovernance {
        emit MintRequested(to, value);
        require(lucr.totalSupply() + value <= maxSupply, "Max supply exceeded");
        lucr.mint(to, value);
        emit MintExecuted(to, value);
    }
}
