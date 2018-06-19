pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract WhitelistedCrowdsale is Crowdsale, Ownable {
    mapping (address => bool) private whitelist;

    event WhitelistedAddressAdded(address indexed _address);
    event WhitelistedAddressRemoved(address indexed _address);

    /**
     * @dev throws if buyer is not whitelisted.
     * @param _buyer address
     */
    modifier onlyIfWhitelisted(address _buyer) {
        require(whitelist[_buyer]);
        _;
    }

    /**
     * @dev getter to determine if address is in whitelist
     */
    function isWhitelisted(address _address) public view returns (bool) {
        return whitelist[_address];
    }

    /**
     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
     * @param _beneficiary Address performing the token purchase
     * @param _weiAmount Value in wei involved in the purchase
     */
    function _preValidatePurchase(
        address _beneficiary,
        uint256 _weiAmount
    )
        onlyIfWhitelisted(_beneficiary)
        internal
    {
        super._preValidatePurchase(_beneficiary, _weiAmount);
    }

    /**
     * @dev add single address to whitelist
     */
    function addAddressToWhitelist(address _address) external onlyOwner {
        whitelist[_address] = true;
        emit WhitelistedAddressAdded(_address);
    }

    /**
     * @dev add addresses to whitelist
     */
    function addAddressesToWhitelist(address[] _addresses) external onlyOwner {
        for (uint i = 0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = true;
            emit WhitelistedAddressAdded(_addresses[i]);
        }
    }

    /**
     * @dev remove single address from whitelist
     */
    function removeAddressFromWhitelist(address _address) external onlyOwner {
        delete whitelist[_address];
        emit WhitelistedAddressRemoved(_address);
    }

    /**
     * @dev remove addresses from whitelist
     */
    function removeAddressesFromWhitelist(address[] _addresses) external onlyOwner {
        for (uint i = 0; i < _addresses.length; i++) {
            delete whitelist[_addresses[i]];
            emit WhitelistedAddressRemoved(_addresses[i]);
        }
    }
}
