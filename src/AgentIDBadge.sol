// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

interface IAgentID {
    function balanceOf(address owner) external view returns (uint256);
}

contract AgentIDBadge is ERC721, Ownable {
    uint256 public constant MAX_SUPPLY = 1000;
    address public immutable agentIdContract;
    uint256 public nextTokenId = 1;
    mapping(address => bool) public hasMinted;
    bool public paused;

    event BadgeMinted(address indexed to, uint256 indexed tokenId);

    error NotAgentIDHolder();
    error AlreadyMinted();
    error MaxSupplyReached();
    error MintPaused();
    error NonexistentToken(uint256 tokenId);
    error ZeroAddress();

    constructor(address _agentIdContract) ERC721("Agent ID Badge", "AIDB") Ownable(msg.sender) {
        if (_agentIdContract == address(0)) revert ZeroAddress();
        agentIdContract = _agentIdContract;
    }

    function mint() external {
        if (paused) revert MintPaused();
        if (IAgentID(agentIdContract).balanceOf(msg.sender) == 0) revert NotAgentIDHolder();
        if (hasMinted[msg.sender]) revert AlreadyMinted();
        if (nextTokenId > MAX_SUPPLY) revert MaxSupplyReached();

        hasMinted[msg.sender] = true;
        uint256 tokenId = nextTokenId;
        _safeMint(msg.sender, tokenId);
        nextTokenId++;
        emit BadgeMinted(msg.sender, tokenId);
    }

    function pause() external onlyOwner {
        paused = true;
    }

    function unpause() external onlyOwner {
        paused = false;
    }

function tokenURI(uint256 tokenId) public view override returns (string memory) {
    if (_ownerOf(tokenId) == address(0)) revert NonexistentToken(tokenId);
    address holder = ownerOf(tokenId);
    string memory svg = _buildSVG(tokenId, holder);
    string memory json = string(abi.encodePacked(
        '{"name":"Agent ID Badge #', Strings.toString(tokenId),
        '","description":"A free commemorative badge for holders of an Agent ID. Minted free (gas only). This badge makes no promise of value, returns, or profit.",',
        '"image":"data:image/svg+xml;base64,', Base64.encode(bytes(svg)), '",',
        '"attributes":[',
        '{"trait_type":"Holder","value":"', Strings.toHexString(holder), '"},',
        '{"trait_type":"Token Number","value":"', Strings.toString(tokenId), '"},',
        '{"trait_type":"Agent ID Verified","value":"Yes"},',
        '{"trait_type":"Mint Price","value":"Free (gas only)"}',
        ']}'
    ));
    return string(abi.encodePacked("data:application/json;base64,", Base64.encode(bytes(json))));
}

function _buildSVG(uint256 tokenId, address holder) internal pure returns (string memory) {
    string memory shortAddr = _shortAddress(holder);
    return string(abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512">',
        '<rect width="512" height="512" fill="#0B0B12"/>',
        '<rect x="16" y="16" width="480" height="480" fill="none" stroke="#D4AF37" stroke-width="4"/>',
        '<rect x="28" y="28" width="456" height="456" fill="none" stroke="#D4AF37" stroke-width="2"/>',
        '<text x="256" y="200" font-family="Arial, sans-serif" font-size="64" font-weight="bold" fill="#D4AF37" text-anchor="middle">AGENT ID</text>',
        '<text x="256" y="280" font-family="Arial, sans-serif" font-size="48" font-weight="bold" fill="#D4AF37" text-anchor="middle">BADGE</text>',
        '<text x="256" y="360" font-family="monospace" font-size="24" fill="#FFFFFF" text-anchor="middle">', shortAddr, '</text>',
        '<text x="256" y="420" font-family="Arial, sans-serif" font-size="20" fill="#D4AF37" text-anchor="middle">TOKEN #', Strings.toString(tokenId), '</text>',
        '<text x="256" y="460" font-family="Arial, sans-serif" font-size="16" fill="#888888" text-anchor="middle">FREE MINT - 1 PER WALLET</text>',
        '</svg>'
    ));
}

function _shortAddress(address holder) internal pure returns (string memory) {
    string memory full = Strings.toHexString(holder);
    bytes memory fullBytes = bytes(full);
    require(fullBytes.length == 42, "invalid address length");
    bytes memory first = new bytes(6);
    bytes memory last = new bytes(4);
    for (uint256 i = 0; i < 6; i++) {
        first[i] = fullBytes[i];
    }
    for (uint256 i = 0; i < 4; i++) {
        last[i] = fullBytes[38 + i];
    }
    return string(abi.encodePacked(first, "...", last));
}
}
