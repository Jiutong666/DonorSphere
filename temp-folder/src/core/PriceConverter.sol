// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract PriceConverter {
    address private _dataFeedAddr;
    AggregatorV3Interface private _dataFeed;

    constructor(address addr) {
        _dataFeedAddr = addr;
        _dataFeed = AggregatorV3Interface(addr);
    }

    function getChainlinkDataFeedLatestAnswer() private view returns (uint256) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int256 price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = _dataFeed.latestRoundData();
        return getPriceInWei(uint256(price));
    }

    /**
     * 将DataFeed返回的价格转换为Wei作为单位
     * 假设ETH/USD 350,000,000,000, decimals是8
     * 1个ETH对应 3500 USD
     */
    function getPriceInWei(uint256 price) private view returns (uint256) {
        return price * (10 ** (18 - _dataFeed.decimals()));
    }

    // 1个eth对应的usd
    function USD(uint256 ethAmount) public view returns (uint256) {
        uint256 price = getChainlinkDataFeedLatestAnswer();
        return (price * ethAmount) / (10 ** 18);
    }
}
