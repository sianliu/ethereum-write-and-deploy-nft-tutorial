//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721URIStorage, Ownable {
    // using Counters for Counters.Counter;
    // Counters.Counter private _tokenIds;
    uint256 private _tokenIdCounter;
    // address private owner; 

    constructor() ERC721("MyNFT", "NFT") Ownable(msg.sender) {}

    // replace mintNFT function
    // @param tokenURI resolves to a json document describing NFT's metadata
    function safeMint(address _receiver, string memory tokenURI) 
        public onlyOwner 
        returns (uint256) 
    {
        uint256 tokenId = _tokenIdCounter;
        _safeMint(_receiver, tokenId);
        _tokenIdCounter += 1; 
        _setTokenURI(tokenId, tokenURI);

        return tokenId; 
    }

    // @param tokenURI string to json file containing NFT metadat
    // function mintNFT(address recipient, string memory tokenURI)
    //     public onlyOwner
    //     returns (uint256)
    // {
    //     _tokenIds.increment();

    //     uint256 newItemId = _tokenIds.current();
    //     _mint(recipient, newItemId);
    //     _setTokenURI(newItemId, tokenURI);

    //     return newItemId;
    // }
}
