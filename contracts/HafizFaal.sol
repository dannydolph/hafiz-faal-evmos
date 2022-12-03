// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HafizFaal is ERC721URIStorage, Pausable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _tokenIdCounter;
    event WishMade(address indexed adr , uint256 omen_number);
    uint private constant OMENS_COUNT = 15;
    struct TakenOmens{
        uint omenId;
        string diary;
    }

    mapping(address => TakenOmens[]) address_to_omens;
    string[OMENS_COUNT] private OmensList = [
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/1.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/2.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/3.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/4.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/5.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/6.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/7.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/8.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/9.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/10.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/11.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/12.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/13.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/14.json",
        "https://gateway.pinata.cloud/ipfs/QmXG1kGuQJNrnVqyU8B9KSukSbRQFkSerbvKkei6b4i5ZC/15.json"
    ];
    constructor() ERC721("HafizFaal", "HFF") {
        for(uint i = 0; i < OMENS_COUNT; i++){
            safeMint(msg.sender);
        }
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to) private onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, OmensList[tokenId]);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function getRandom() view private returns(uint rnd){
        //TODO: get real random number from oracles like Chainlink
        rnd = block.number % OMENS_COUNT;
    }

    function makeWish(string memory diary) public payable returns(string memory omen){
        require(msg.value == 0.01 ether , "The value must be 0.01eth");
        uint rnd = getRandom();
        address_to_omens[msg.sender].push(TakenOmens(rnd, diary));
        payable(ownerOf(rnd)).transfer(0.009 ether);
        emit WishMade(msg.sender, rnd);
        omen = OmensList[rnd];
    }

    function getOmensHistory() view public returns(TakenOmens[] memory){
        return address_to_omens[msg.sender];
    }

    function withdraw() public onlyOwner{
        payable(owner()).transfer(address(this).balance);
    }
}
