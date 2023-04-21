// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Light is ERC721, Pausable, Ownable, ERC721Burnable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public constant MAX_NFTS = 1000;
    uint256 public constant PRICE = 0.1 ether;

    string private _baseTokenURI;
    
    constructor(string memory baseURI) ERC721("Light", "LGT") {
        _baseTokenURI = baseURI;
    }
    
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mintNFT() public payable {
        require(msg.value >= PRICE, "Not enough payment");
        require(_tokenIds.current() < MAX_NFTS, "All NFTs are minted");

        uint256 newItemId = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, _tokenIds.current())));
        newItemId = newItemId % MAX_NFTS;

        _safeMint(msg.sender, newItemId);

        _tokenIds.increment();
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
    {
        super._beforeTokenTransfer(from, to, tokenId, 1);
    }
}
