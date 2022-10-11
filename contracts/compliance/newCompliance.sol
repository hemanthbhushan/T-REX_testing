/**
 *Submitted for verification at polygonscan.com on 2021-12-09
*/

pragma solidity ^0.8.11;

contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }

    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() external view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() external virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal virtual {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface ICompliance {

    /**
    *  this event is emitted when the Agent has been added on the allowedList of this Compliance.
    *  the event is emitted by the Compliance constructor and by the addTokenAgent function
    *  `_agentAddress` is the address of the Agent to add
    */
    event TokenAgentAdded(address _agentAddress);

    /**
    *  this event is emitted when the Agent has been removed from the agent list of this Compliance.
    *  the event is emitted by the Compliance constructor and by the removeTokenAgent function
    *  `_agentAddress` is the address of the Agent to remove
    */
    event TokenAgentRemoved(address _agentAddress);

    /**
    *  this event is emitted when a token has been bound to the compliance contract
    *  the event is emitted by the bindToken function
    *  `_token` is the address of the token to bind
    */
    event TokenBound(address _token);

    /**
    *  this event is emitted when a token has been unbound from the compliance contract
    *  the event is emitted by the unbindToken function
    *  `_token` is the address of the token to unbind
    */
    event TokenUnbound(address _token);

    /**
    *  @dev Returns true if the Address is in the list of token agents
    *  @param _agentAddress address of this agent
    */
    function isTokenAgent(address _agentAddress) external view returns (bool);

    /**
    *  @dev Returns true if the address given corresponds to a token that is bound with the Compliance contract
    *  @param _token address of the token
    */
    function isTokenBound(address _token) external view returns (bool);

    /**
     *  @dev adds an agent to the list of token agents
     *  @param _agentAddress address of the agent to be added
     *  Emits a TokenAgentAdded event
     */
    function addTokenAgent(address _agentAddress) external;

    /**
    *  @dev remove Agent from the list of token agents
    *  @param _agentAddress address of the agent to be removed (must be added first)
    *  Emits a TokenAgentRemoved event
    */
    function removeTokenAgent(address _agentAddress) external;

    /**
     *  @dev binds a token to the compliance contract
     *  @param _token address of the token to bind
     *  Emits a TokenBound event
     */
    function bindToken(address _token) external;

    /**
    *  @dev unbinds a token from the compliance contract
    *  @param _token address of the token to unbind
    *  Emits a TokenUnbound event
    */
    function unbindToken(address _token) external;


    /**
     *  @dev checks that the transfer is compliant.
     *  default compliance always returns true
     *  READ ONLY FUNCTION, this function cannot be used to increment
     *  counters, emit events, ...
     *  @param _from The address of the sender
     *  @param _to The address of the receiver
     *  @param _amount The amount of tokens involved in the transfer
     */
    function canTransfer(address _from, address _to, uint256 _amount) external view returns (bool);

    /**
     *  @dev function called whenever tokens are transferred
     *  from one wallet to another
     *  this function can update state variables in the compliance contract
     *  these state variables being used by `canTransfer` to decide if a transfer
     *  is compliant or not depending on the values stored in these state variables and on
     *  the parameters of the compliance smart contract
     *  @param _from The address of the sender
     *  @param _to The address of the receiver
     *  @param _amount The amount of tokens involved in the transfer
     */
    function transferred(address _from, address _to, uint256 _amount) external;

    /**
     *  @dev function called whenever tokens are created
     *  on a wallet
     *  this function can update state variables in the compliance contract
     *  these state variables being used by `canTransfer` to decide if a transfer
     *  is compliant or not depending on the values stored in these state variables and on
     *  the parameters of the compliance smart contract
     *  @param _to The address of the receiver
     *  @param _amount The amount of tokens involved in the transfer
     */
    function created(address _to, uint256 _amount) external;

    /**
     *  @dev function called whenever tokens are destroyed
     *  this function can update state variables in the compliance contract
     *  these state variables being used by `canTransfer` to decide if a transfer
     *  is compliant or not depending on the values stored in these state variables and on
     *  the parameters of the compliance smart contract
     *  @param _from The address of the receiver
     *  @param _amount The amount of tokens involved in the transfer
     */
    function destroyed(address _from, uint256 _amount) external;

    /**
     *  @dev function used to transfer the ownership of the compliance contract
     *  to a new owner, giving him access to the `OnlyOwner` functions implemented on the contract
     *  @param newOwner The address of the new owner of the compliance contract
     *  This function can only be called by the owner of the compliance contract
     *  emits an `OwnershipTransferred` event
     */
    function transferOwnershipOnComplianceContract(address newOwner) external;
}

interface IIdentityRegistry {
    /**
    *  @dev Returns the onchainID of an investor.
    *  @param _userAddress The wallet of the investor
    */
    function identity(address _userAddress) external view returns (address);

    /**
    *  @dev Returns the country code of an investor.
    *  @param _userAddress The wallet of the investor
    */
    function investorCountry(address _userAddress) external view returns (uint16);
}

interface IToken {
    /**
    *  @dev Returns the Identity Registry linked to the token
    */
    function identityRegistry() external view returns (IIdentityRegistry);
}

abstract contract BasicCompliance is Ownable, ICompliance {

    /// Mapping between agents and their statuses
    mapping(address => bool) private _tokenAgentsList;

    /// Mapping of tokens linked to the compliance contract
    IToken _tokenBound;

    /**
     * @dev Throws if called by any address that is not a token bound to the compliance.
     */
    modifier onlyToken() {
        require(isToken(), "error : this address is not a token bound to the compliance contract");
        _;
    }

    /**
    *  @dev Returns the ONCHAINID (Identity) of the _userAddress
    *  @param _userAddress Address of the wallet
    */
    function _getIdentity(address _userAddress) internal view returns (address) {
        return address(_tokenBound.identityRegistry().identity(_userAddress));
    }

    function _getCountry(address _userAddress) internal view returns (uint16) {
        return _tokenBound.identityRegistry().investorCountry(_userAddress);
    }

    /**
    *  @dev See {ICompliance-isTokenAgent}.
    */
    function isTokenAgent(address _agentAddress) public override view returns (bool) {
        if (!_tokenAgentsList[_agentAddress]) {
            return false;
        }
        return true;
    }

    /**
    *  @dev See {ICompliance-isTokenBound}.
    */
    function isTokenBound(address _token) public override view returns (bool) {
        if (_token != address(_tokenBound)){
            return false;
        }
        return true;
    }

    /**
     *  @dev See {ICompliance-addTokenAgent}.
     */
    function addTokenAgent(address _agentAddress) external override onlyOwner {
        require(!_tokenAgentsList[_agentAddress], "This Agent is already registered");
        _tokenAgentsList[_agentAddress] = true;
        emit TokenAgentAdded(_agentAddress);
    }

    /**
    *  @dev See {ICompliance-isTokenAgent}.
    */
    function removeTokenAgent(address _agentAddress) external override onlyOwner {
        require(_tokenAgentsList[_agentAddress], "This Agent is not registered yet");
        _tokenAgentsList[_agentAddress] = false;
        emit TokenAgentRemoved(_agentAddress);
    }

    /**
     *  @dev See {ICompliance-bindToken}.
     */
    function bindToken(address _token) external override onlyOwner {
        require(_token != address(_tokenBound), "This token is already bound");
        _tokenBound = IToken(_token);
        emit TokenBound(_token);
    }

    /**
    *  @dev See {ICompliance-unbindToken}.
    */
    function unbindToken(address _token) external override onlyOwner {
        require(_token == address(_tokenBound), "This token is not bound yet");
        delete _tokenBound;
        emit TokenUnbound(_token);
    }

    /**
    *  @dev Returns true if the sender corresponds to a token that is bound with the Compliance contract
    */
    //here the msg.sender should be the token
    function isToken() internal view returns (bool) {
        return isTokenBound(msg.sender);
    }

    /**
    *  @dev See {ICompliance-transferOwnershipOnComplianceContract}.
    */
    function transferOwnershipOnComplianceContract(address newOwner) external override onlyOwner {
        transferOwnership(newOwner);
    }

}



abstract contract CountryRestrictions is BasicCompliance {

    /**
     *  this event is emitted whenever a Country has been restricted.
     *  the event is emitted by 'addCountryRestriction' and 'batchRestrictCountries' functions.
     *  `_country` is the numeric ISO 3166-1 of the restricted country.
     */
    event AddedRestrictedCountry(uint16 _country);

    /**
     *  this event is emitted whenever a Country has been unrestricted.
     *  the event is emitted by 'removeCountryRestriction' and 'batchUnrestrictCountries' functions.
     *  `_country` is the numeric ISO 3166-1 of the unrestricted country.
     */
    event RemovedRestrictedCountry(uint16 _country);

    /// Mapping between country and their restriction status
    mapping(uint16 => bool) private _restrictedCountries;

    /**
    *  @dev Returns true if country is Restricted
    *  @param _country, numeric ISO 3166-1 standard of the country to be checked
    */
    function isCountryRestricted(uint16 _country) public view returns (bool) {
        return (_restrictedCountries[_country]);
    }

    /**
    *  @dev Adds country restriction.
    *  Identities from those countries will be forbidden to manipulate Tokens linked to this Compliance.
    *  @param _country Country to be restricted, should be expressed by following numeric ISO 3166-1 standard
    *  Only the owner of the Compliance smart contract can call this function
    *  emits an `AddedRestrictedCountry` event
    */
    function addCountryRestriction(uint16 _country) public onlyOwner {
        _restrictedCountries[_country] = true;
        emit AddedRestrictedCountry(_country);
    }

    /**
     *  @dev Removes country restriction.
     *  Identities from those countries will again be authorised to manipulate Tokens linked to this Compliance.
     *  @param _country Country to be unrestricted, should be expressed by following numeric ISO 3166-1 standard
     *  Only the owner of the Compliance smart contract can call this function
     *  emits an `RemovedRestrictedCountry` event
     */
    function removeCountryRestriction(uint16 _country) public onlyOwner {
        _restrictedCountries[_country] = false;
        emit RemovedRestrictedCountry(_country);
    }

    /**
    *  @dev Adds countries restriction in batch.
    *  Identities from those countries will be forbidden to manipulate Tokens linked to this Compliance.
    *  @param _countries Countries to be restricted, should be expressed by following numeric ISO 3166-1 standard
    *  Only the owner of the Compliance smart contract can call this function
    *  emits an `AddedRestrictedCountry` event
    */
    function batchRestrictCountries(uint16[] memory _countries) public onlyOwner {
        for (uint i = 0; i < _countries.length; i++) {
            _restrictedCountries[_countries[i]] = true;
            emit AddedRestrictedCountry(_countries[i]);
        }
    }

    /**
     *  @dev Removes countries restriction in batch.
     *  Identities from those countries will again be authorised to manipulate Tokens linked to this Compliance.
     *  @param _countries Countries to be unrestricted, should be expressed by following numeric ISO 3166-1 standard
     *  Only the owner of the Compliance smart contract can call this function
     *  emits an `RemovedRestrictedCountry` event
     */
    function batchUnrestrictCountries(uint16[] memory _countries) public onlyOwner {
        for (uint i = 0; i < _countries.length; i++) {
            _restrictedCountries[_countries[i]] = false;
            emit RemovedRestrictedCountry(_countries[i]);
        }
    }

    function transferActionOnCountryRestrictions(address _from, address _to, uint256 _value) internal {}

    function creationActionOnCountryRestrictions(address _to, uint256 _value) internal {}

    function destructionActionOnCountryRestrictions(address _from, uint256 _value) internal {}


    function complianceCheckOnCountryRestrictions (address _from, address _to, uint256 _value)
    internal view returns (bool) {
        uint16 receiverCountry = _getCountry(_to);
        //the _getIdentity checks all the reuire statements in the identitystorageregistry
        address senderIdentity = _getIdentity(_from);
        if (isCountryRestricted(receiverCountry)) {
            return false;
        }
        return true;
    }
}



abstract contract DayMonthLimits is BasicCompliance {

    /**
     *  this event is emitted whenever a DailyLimit has been updated.
     *  the event is emitted by 'setDailyLimit' and by Compliance's constructor.
     *  `_newDailyLimit` is the amount Limit of tokens to be transferred daily.
     */
    event DailyLimitUpdated(uint _newDailyLimit);

    /**
     *  this event is emitted whenever a MonthlyLimit has been updated.
     *  the event is emitted by 'setMonthlyLimit' and by Compliance's constructor.
     *  `_newMonthlyLimit` is the amount Limit of tokens to be transferred monthly.
     */
    event MonthlyLimitUpdated(uint _newMonthlyLimit);

    /// Getter for Tokens dailyLimit
    uint256 public dailyLimit;

    /// Getter for Tokens monthlyLimit
    uint256 public monthlyLimit;

    /// Struct of transfer Counters
    struct TransferCounter {
        uint256 dailyCount;
        uint256 monthlyCount;
        uint256 dailyTimer;
        uint256 monthlyTimer;
    }

    /// Mapping for users Counters
    mapping(address => TransferCounter) usersCounters;

    /**
    *  @dev checks if the day has finished since the cooldown has been triggered for this identity
    *  @param _identity ONCHAINID to be checked
    */
    function _isDayFinished(address _identity) internal view returns (bool) {
        return (usersCounters[_identity].dailyTimer <= block.timestamp);
    }

    /**
    *  @dev checks if the month has finished since the cooldown has been triggered for this identity
    *  @param _identity ONCHAINID to be checked
    */
    function _isMonthFinished(address _identity) internal view returns (bool) {
        return (usersCounters[_identity].monthlyTimer <= block.timestamp);
    }

    /**
    *  @dev resets cooldown for the day if cooldown has reached time limit of 1 day
    *  @param _identity ONCHAINID to be checked
    */
    function _resetDailyCooldown(address _identity) internal {
        if (_isDayFinished(_identity)) {
            usersCounters[_identity].dailyTimer = block.timestamp + 1 days;
            usersCounters[_identity].dailyCount = 0;
        }
    }

    /**
    *  @dev resets cooldown for the month if cooldown has reached the time limit of 30days
    *  @param _identity ONCHAINID to be checked
    */
    function _resetMonthlyCooldown(address _identity) internal {
        if (_isMonthFinished(_identity)) {
            usersCounters[_identity].monthlyTimer = block.timestamp + 30 days;
            usersCounters[_identity].monthlyCount = 0;
        }
    }

    /**
    *  @dev Checks if daily and/or monthly cooldown must be reset, then check if _value sent has been exceeded,
    *  if not increases user's OnchainID counters.
    *  @param _userAddress, address on which counters will be increased
    *  @param _value, value of transaction)to be increased


    */

    //here increasing the dialy transfer limit for the user it first checks if the dialy cooldown is reached if it is reached then it will get reset
    //the dialy count increased should should be less than the dialy limit
    //when ever the transfer is done it willl be added to the from address
    function _increaseCounters(address _userAddress, uint256 _value) internal {
        address identity = _getIdentity(_userAddress);
        _resetDailyCooldown(identity);
        _resetMonthlyCooldown(identity);
        if ((usersCounters[identity].dailyCount + _value) <= dailyLimit) {
            usersCounters[identity].dailyCount += _value;
        }
        if ((usersCounters[identity].monthlyCount + _value) <= monthlyLimit) {
            usersCounters[identity].monthlyCount += _value;
        }
    }

    /**
    *  @dev Set the limit of tokens allowed to be transferred daily.
    *  @param _newDailyLimit The new daily limit of tokens
    */
    function setDailyLimit(uint256 _newDailyLimit) public onlyOwner {
        dailyLimit = _newDailyLimit;
        emit DailyLimitUpdated(_newDailyLimit);
    }

    /**
     *  @dev Set the limit of tokens allowed to be transferred monthly.
     *  param _newMonthlyLimit The new monthly limit of tokens
     */
    function setMonthlyLimit(uint256 _newMonthlyLimit) public onlyOwner {
        monthlyLimit = _newMonthlyLimit;
        emit MonthlyLimitUpdated(_newMonthlyLimit);
    }

    function transferActionOnDayMonthLimits(address _from, address _to, uint256 _value) internal {
        _increaseCounters(_from, _value);
    }

    function creationActionOnDayMonthLimits(address _to, uint256 _value) internal {}

    function destructionActionOnDayMonthLimits(address _from, uint256 _value) internal {}

//its is a internal function checking ever function is in compliance with rules or not 
    function complianceCheckOnDayMonthLimits(address _from, address _to, uint256 _value) internal view returns (bool) {
        address senderIdentity = _getIdentity(_from);
        //from should not be the tokenagent 
        if (!isTokenAgent(_from)) {
            //the entered value should not exceed the day limit
            if (_value > dailyLimit) {
                return false;
            }
            //checking weather the day is finished if it is finished need to reset using this funtion _resetDailyCooldown(address _identity)
            if (!_isDayFinished(senderIdentity) &&
              //dialy count of the user should not exceed the day limit
            ((usersCounters[senderIdentity].dailyCount + _value > dailyLimit)
             //monthly count of the user should not exceed the monthly limit
            || (usersCounters[senderIdentity].monthlyCount + _value > monthlyLimit))) {
                return false;
            }
            //monthly count of the user should not exceed the monthly limit
            if (_isDayFinished(senderIdentity) && _value + usersCounters[senderIdentity].monthlyCount > monthlyLimit) {
                 //checking weather the month is finished if it is finished it will return true
                return(_isMonthFinished(senderIdentity));
            }
        }
        return true;
    }

}


contract ComplianceEGXCountriesAndTransferLimits is CountryRestrictions, DayMonthLimits {
    uint[] public features;

    constructor () public {
        features = [1,2];

        uint16[] memory restrictedCountries = new uint16[](16);
        uint16[16] memory inputRestrictedCountries = [uint16(364), 408,376,44,231,288,688,144,760,780,788,887,586,104,548,4];
        for (uint i = 0; i < inputRestrictedCountries.length; i++) {
            restrictedCountries[i] = inputRestrictedCountries[i];
        }
        batchRestrictCountries(restrictedCountries);
        setDailyLimit(50000);
        setMonthlyLimit(500000);
    }

    function getFeatures() public view returns(uint[] memory) {
        return features;
    }

    /**
    *  @dev See {ICompliance-transferred}.
    //all these might be called by the token ,initially there is  IToken _tokenBound;
    */
    function transferred(address _from, address _to, uint256 _value) external onlyToken override {
        transferActionOnCountryRestrictions(_from, _to, _value);
        transferActionOnDayMonthLimits(_from, _to, _value);
    }

    /**
    *  @dev See {ICompliance-created}.
    */
    function created(address _to, uint256 _value) external onlyToken override {
        creationActionOnCountryRestrictions(_to, _value);
        creationActionOnDayMonthLimits(_to, _value);
    }

    /**
     *  @dev See {ICompliance-destroyed}.
     */
    function destroyed(address _from, uint256 _value) external onlyToken override {
        destructionActionOnCountryRestrictions(_from, _value);
        destructionActionOnDayMonthLimits(_from, _value);
    }

    /**
     *  @dev See {ICompliance-canTransfer}.
     */
    function canTransfer(address _from, address _to, uint256 _value) external view override returns (bool) {
        if (!complianceCheckOnCountryRestrictions(_from, _to, _value)) {
            return false;
        }
        if (!complianceCheckOnDayMonthLimits(_from, _to, _value)) {
            return false;
        }

        return true;
    }
}