// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract QuantumNFT is ERC721, Ownable {
    using Strings for uint256;

    // Mapping from token ID to the data URI
    mapping(uint256 => string) private _tokenURIs;

    // Event that is emitted when a token's data URI is set
    event TokenURISet(uint256 indexed tokenId, string dataURI);

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    // The function to set the data URI for a given token
    // Use ERC721URIStorage don't write our own! 
    function setTokenURI(uint256 tokenId, string memory dataURI) public onlyOwner {
        require(_exists(tokenId), "QuantumNFT: URI set of nonexistent token");
        _tokenURIs[tokenId] = dataURI;
        emit TokenURISet(tokenId, dataURI);
    }

    // Overriding the tokenURI method of the ERC721 standard to return the data URI
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "QuantumNFT: URI query for nonexistent token");
        
        string memory _tokenURI = _tokenURIs[tokenId];
        return bytes(_tokenURI).length > 0 ? _tokenURI : super.tokenURI(tokenId);
        // return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId.toString()) : "";
    }

     /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     * 
     3
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    // copied from QuantumNFT.sol
    // @quantum_state is the result from nftQScript
    // @dev returns tokenId
    function mint(string memory circuit, 
                  uint8 num_qubits, 
                  uint256[] memory quantum_state) public returns (uint256) {
            
        // 1. compute circuitId
        // need circuit to compute circuitId
        circuitId = bytes16(keccak256(bytes(circuit)));         // bytes32
        
        require(getHasMinted(msg.sender, circuitId) == false, "You have already minted this circuit.");

        // 2. compute tokenId
        _index.increment();
        uint256 newItemId = _index.current();
        _tokenId = uint256(circuitId) + newItemId;

        _safeMint(msg.sender, _tokenId);
        // _lock(quantumnftOwner, _tokenId); 
        mintOncePerType[msg.sender][circuitId] = true; 
    
        // construct dataURI 
        string memory base = 'data:application/json;base64,';
        string memory json = string(
            abi.encodePacked(
              "{\n\t\"Name:\"", Strings.toString(_tokenId),
                "\"\n\t\"Qubits:\"", Strings.toString(num_qubits),
                "\"\n\t\"State: \"", uint256ArrayToString(quantum_state),
                "\"\n}"
            )
        ); // format json

        string memory dataURI = string(abi.encodePacked(base, Base64.encode(bytes(json)))); 
        console.log("Data URI: ", dataURI); 

        // 4. calls setTokenURI from ERC721URIStorage
        _setTokenURI(_tokenId, dataURI);

        return _tokenId; 
    }

}
