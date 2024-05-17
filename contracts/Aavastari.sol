// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "./AvastariNFT.sol";

contract AVASTARI is ERC20, ERC20Pausable, Ownable, ERC20Permit {
    AvastariNFT public nftContract;
    AggregatorV3Interface internal priceFeed;

    uint256 maxNftAward =  2342;
    uint256 public nftcount = 0;

    mapping (address => bool) public isAwardedNft;

    constructor( address _nftAddress)
        ERC20("AVASTARI", "ASTRI")
        Ownable()
        ERC20Permit("AVASTARI")
    {
        nftContract = AvastariNFT(_nftAddress);
        priceFeed = AggregatorV3Interface(0x14e613AC84a31f709eadbdF89C6CC390fDc9540A);
    }

    function pause() public onlyOwner 
    {
        _pause();
    }

    function unpause() public onlyOwner 
    {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner 
    {
        _mint(to, amount);
    }

    function getLatestPrice() public view returns (int) 
    {
        (,int price,,,) = priceFeed.latestRoundData();
        return price;
    }

    function buy(uint256 amount) public payable {
        int price = getLatestPrice();

        _mint(msg.sender, amount);

        if(msg.value * uint256(price) >= amount * 1e18 && nftcount < maxNftAward && !isAwardedNft[msg.sender]){
            uint256 nftId = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
            nftContract.mint(msg.sender, nftId, 1, "");
            nftcount += 1;
            isAwardedNft[msg.sender] = true;
        }
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Pausable) 
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}