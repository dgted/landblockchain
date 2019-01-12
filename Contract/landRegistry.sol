pragma solidity ^0.4.25;

contract landRegistration {
    
    struct userDetail{
        bytes32 fullName;
        bytes32 fatheName;
        bytes32 district;
        bytes32 thana;
        uint24 postCode;
        bytes32 village;
        bool isExist;
    }
    
    struct userOwned{
        uint number;
        bytes32[] khatianList;
    }
    
    struct khatian{
        uint64 khatianiId;
        bytes32 plotHash;
        uint16 percentOwn;
        bytes32 buyFrom;
        bytes32[] sellTo;
        uint16[] sellPercentage;
        uint[] ownerArray;
        uint16[] perOwnerPercentage;
        bool isExist;
    }
    
    struct plot{
        bytes32 division;
        bytes32 district;
        bytes32 thana;
        uint16 JLNo;
        uint16 plotNo;
        uint8 plotType;
        uint32 plotArea;
        bool isExist;
    }
    
    mapping (uint => userOwned)  userOwnedMapping;
    
    mapping (uint => userDetail)  userMapping;
    uint[]   userArray;
    
    mapping (bytes32 => plot)  plotMapping;
    bytes32[]   plotArray;
    
    mapping (bytes32 => khatian)  khatianMapping;
    bytes32[]   khatianArray;
    
    
    address contarctOwner;
    
    event creationOfplot(bytes32 plotHash);
    event creationOfUser(uint nid);
    event creationOfKhatian(bytes32 khatianHash);
    
    constructor() public {
        contarctOwner = msg.sender;
    }
    
    function addKhatianNew(uint64 _khatianiId, bytes32 _plotHash, uint16 _percentOwn, uint[] _user, uint16[] _percentage) public{
        require(msg.sender == contarctOwner, "Sender is not authorized");
        require(plotMapping[_plotHash].isExist == true, "Plot doesn't exist");
        bytes32 khatianHash = keccak256(abi.encodePacked(_khatianiId, _plotHash));
        require(khatianMapping[khatianHash].isExist != true, "Khatian already exists");
        for(uint j = 0; j< _user.length; j++){
             require(userMapping[_user[j]].isExist == true, "User's NID doesn't exist");
        }
        
        khatianMapping[khatianHash].khatianiId = _khatianiId;
        khatianMapping[khatianHash].plotHash = _plotHash;
        khatianMapping[khatianHash].percentOwn = _percentOwn;
        khatianMapping[khatianHash].isExist = true;
        khatianMapping[khatianHash].perOwnerPercentage = _percentage;
        khatianMapping[khatianHash].ownerArray = _user;
        
        for(uint i = 0; i< _user.length; i++){
            addUserOwned(_user[i], khatianHash);
        }
        
        khatianArray.push(khatianHash);
        emit creationOfKhatian(khatianHash);
    }
    
    function addKhatianFromOld(uint64 _khatianiId, bytes32 _plotHash, uint16 _percentOwn, bytes32 _buyFrom, uint[] _user, uint16[] _percentage) public{
        require(msg.sender == contarctOwner, "Sender is not authorized");
        require(plotMapping[_plotHash].isExist == true, "Plot doesn't exist");
        
        bytes32 khatianHash = keccak256(abi.encodePacked(_khatianiId, _plotHash));
        
        require(khatianMapping[khatianHash].isExist != true, "Khatian already exists");
        require(khatianMapping[_buyFrom].isExist, "previous Khatian doesn't exist");
        require(khatianMapping[_buyFrom].percentOwn >= _percentOwn, "Not enough land to sell");
        for(uint j = 0; j< _user.length; j++){
             require(userMapping[_user[j]].isExist == true, "User's NID doesn't exist");
        }
        
        khatianMapping[_buyFrom].sellTo.push(khatianHash);
        khatianMapping[_buyFrom].sellPercentage.push(_percentOwn);
        khatianMapping[_buyFrom].percentOwn  -= _percentOwn;
        
        khatianMapping[khatianHash].buyFrom = _buyFrom;
        khatianMapping[khatianHash].khatianiId = _khatianiId;
        khatianMapping[khatianHash].plotHash = _plotHash;
        khatianMapping[khatianHash].percentOwn = _percentOwn;
        khatianMapping[khatianHash].isExist = true;
        khatianMapping[khatianHash].perOwnerPercentage = _percentage;
        khatianMapping[khatianHash].ownerArray = _user;
        
        for(uint i = 0; i< _user.length; i++){
            addUserOwned(_user[i], khatianHash);
        }
        
        khatianArray.push(khatianHash);
        
        emit creationOfKhatian(khatianHash);
    }
    
    function addUserOwned(uint _uid, bytes32 _khatianHash) public{
        userOwnedMapping[_uid].number ++;
        userOwnedMapping[_uid].khatianList.push(_khatianHash);
    }
    
    function getKhatianArrayLen() public view returns(uint len){
        return khatianArray.length;
    }
    
    function getKhatianHasById(uint id) public view returns(bytes32 khatianHash){
        return khatianArray[id];
    }
    
    function getKhatianByHash(bytes32 khatianHash) public view returns(uint64 khatianiId, bytes32 plotHash, uint16 percentOwn, bytes32 buyFrom, bytes32[] sellTo, uint16[] sellPercentage, uint[] ownerArray, uint16[] perOwnerPercentage){
        require(khatianMapping[khatianHash].isExist == true, "Khatian doesn't exist");
        khatianiId = khatianMapping[khatianHash].khatianiId;
        plotHash = khatianMapping[khatianHash].plotHash;
        percentOwn = khatianMapping[khatianHash].percentOwn;
        buyFrom = khatianMapping[khatianHash].buyFrom;
        sellTo = khatianMapping[khatianHash].sellTo;
        sellPercentage = khatianMapping[khatianHash].sellPercentage;
        ownerArray = khatianMapping[khatianHash].ownerArray;
        perOwnerPercentage = khatianMapping[khatianHash].perOwnerPercentage;
        
    }
    
    function addPlot(string _division, string _district, string _thana, uint16 _JLNo, uint16 _plotNo, uint8 _plotType, uint32 _plotArea) public{
        require(msg.sender == contarctOwner, "You are not authorized");
        _division = toUpper(_division);
        _district = toUpper(_district);
        _thana = toUpper(_thana);
        bytes32 plotHash = keccak256(abi.encodePacked(_division, _district, _thana, _JLNo, _plotNo));
        require(plotMapping[plotHash].isExist != true, "Plot already exsits");
        plotMapping[plotHash].division = stringToBytes32(_division);
        plotMapping[plotHash].district = stringToBytes32(_district);
        plotMapping[plotHash].thana = stringToBytes32(_thana);
        plotMapping[plotHash].JLNo = _JLNo;
        plotMapping[plotHash].plotNo = _plotNo;
        plotMapping[plotHash].plotType = _plotType;
        plotMapping[plotHash].plotArea = _plotArea;
        plotMapping[plotHash].isExist = true;
        plotArray.push(plotHash);
        emit creationOfplot(plotHash);
    }
    
    
    function getPlotArrayLen() public view returns(uint len){
        return plotArray.length;
    }
    
    function getPlotHashById(uint id) public view returns(bytes32 plotHash){
        return plotArray[id];
    }
    
    function getPlotByHash(bytes32 plotHash) public view returns(bytes32 division, bytes32 district, bytes32 thana, uint16 JLNo, uint16 plotNo, uint8 plotType, uint32 plotArea){
        require(plotMapping[plotHash].isExist == true, "Plot doesn't exist");
        division = plotMapping[plotHash].division;
        district = plotMapping[plotHash].district;
        thana = plotMapping[plotHash].thana;
        JLNo = plotMapping[plotHash].JLNo;
        plotNo = plotMapping[plotHash].plotNo;
        plotType = plotMapping[plotHash].plotType;
        plotArea = plotMapping[plotHash].plotArea;
    }
    
    function creatNewUser(string _fullName, string _fatheName, string _district, string _thana, uint24 _postCode, string _village, uint _nid) public{
        require(msg.sender == contarctOwner, "You are not authorized");
        _fullName = toUpper(_fullName);
        _fatheName = toUpper(_fatheName);
        _district = toUpper(_district);
        _thana = toUpper(_thana);
        _village = toUpper(_village);
        require(userMapping[_nid].isExist == false, "User already exist");
        
        userMapping[_nid].fullName = stringToBytes32(_fullName);
        userMapping[_nid].fatheName = stringToBytes32(_fatheName);
        userMapping[_nid].district = stringToBytes32(_district);
        userMapping[_nid].thana = stringToBytes32(_thana);
        userMapping[_nid].postCode = _postCode;
        userMapping[_nid].village = stringToBytes32(_village);
        userMapping[_nid].isExist = true;
        
        userArray.push(_nid);
        emit creationOfUser(_nid);
    }
    
    function getUserArrayLen() public view returns(uint len){
        return userArray.length;
    }
    
    function getUserIdById(uint id) public view returns(uint UserId){
        return userArray[id];
    }
    
    function getUserByNid(uint _nid) public view returns(bytes32 fullName, bytes32 fatheName, bytes32 district, bytes32 thana, uint24 postCode, bytes32 village){
        require(userMapping[_nid].isExist == true, "User Doesn't exist");
        fullName = userMapping[_nid].fullName;
        fatheName = userMapping[_nid].fatheName;
        district = userMapping[_nid].district;
        thana = userMapping[_nid].thana;
        postCode = userMapping[_nid].postCode;
        village = userMapping[_nid].village;
    }
    
    function getUserOwnedByUid(uint _uid) public view returns(uint number, bytes32[] khatianList){
        number = userOwnedMapping[_uid].number;
        khatianList =  userOwnedMapping[_uid].khatianList;
    }
    
    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }
    
    function toUpper(string str) internal pure returns (string) {
		bytes memory bStr = bytes(str);
		bytes memory bUpper = new bytes(bStr.length);
		for (uint i = 0; i < bStr.length; i++) {
			if ((bStr[i] >= 97) && (bStr[i] <= 122)) {
				bUpper[i] = bytes1(int(bStr[i]) - 32);
			} else {
				bUpper[i] = bStr[i];
			}
		}
		return string(bUpper);
	}
}
