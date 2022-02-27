// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC721, Ownable {
    struct Pet {
        uint8 damage; // 0-256
        uint8 magic;
        uint256 lastMeal; // when this pet last got feed
        uint256 endurance; // how log does the pet goes without food
    }

    uint256 nextId = 0;

    mapping(uint256 => Pet) private _tokenDetails;

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}

    function getTokenDetails(uint256 tokenId) public view returns (Pet memory) {
        return _tokenDetails[tokenId];
    }

    function mint(
        uint8 damage,
        uint8 magic,
        uint256 endurance
    ) public onlyOwner {
        _tokenDetails[nextId] = Pet(damage, magic, block.timestamp, endurance);
        _safeMint(msg.sender, nextId);
        nextId++;
    }

    function feed(uint256 tokenId) public {
        Pet storage pet = _tokenDetails[tokenId];
        require(
            pet.lastMeal + pet.endurance > block.timestamp,
            "Alas your pet is already dead..."
        );
        pet.lastMeal = block.timestamp;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal view override {
        Pet storage pet = _tokenDetails[tokenId];
        require(
            pet.lastMeal + pet.endurance > block.timestamp,
            "Alas your pet is already dead..."
        );
    }
}
