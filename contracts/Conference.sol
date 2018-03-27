pragma solidity ^0.4.15;

import "./Ownable.sol";

contract Conference is Ownable{

  //custom Types
  struct Talk {
    uint id;
    string title;
    string location;
    uint startTime;
    uint endTime;
    bool cancelled;
    address[] speakers;
  }

  struct Speaker {
    address account;
    bytes32 fullName; 
    uint[] talksId;
    //bytes32 containthe fix size of array characters in solidity
  }
	
	//state variables;
 mapping(uint => Talk) public talks;

 mapping(address => Speaker) public speakers;

 uint totalTalks;
 //maping is type of hash array
 //mapping is associative array ,but it is not way to check the key exist,or iterate



	// string public title;
	// string public location;
	// uint public startTime;
	// uint public endTime;
	// address public speakerAddress;
	// string public speakerName;


address public attendeeAddress;
string public attendeeName;
uint256 constant REGISTRATION_PRICE = 1800000000000000000;


//Modifiers
modifier onlyOwner() {
  require(msg.sender == owner);
  _;
}


  // Add a event that notify
  event AddTalkEvent(uint indexed _id,string _title,uint _startTime,uint _endTime);
  event RegisterEvent(address indexed _account,string _name);
    modifier restricted() {
        if (msg.sender == owner) _;
    }


	function Conference() {
	owner = msg.sender;
	}





// get the talk
//solidity support multiple returns
function addTalk(
  string _title,
  string _location,
  uint _startTime,
  uint _endTime,
  address[] _speakerAddress,
  bytes32[]_speakerName
  )public onlyOwner {
//check required fields
require(bytes(_title).length > 0);
require(_startTime > 0);
require(_endTime > _startTime);
require(_speakerAddress.length > 0);

// a new talk
totalTalks++;

// store this talk
talks[totalTalks].id = totalTalks;
talks[totalTalks].title = _title;
talks[totalTalks].location = _location;
talks[totalTalks].startTime = _startTime;
talks[totalTalks].endTime = _endTime;
 // store the speakers
 for(uint i = 0; i < _speakerAddress.length;i++){
  //add or update speaker details
  require(_speakerAddress[i] != 0);

  speakers[_speakerAddress[i]].account = _speakerAddress[i];
  speakers[_speakerAddress[i]].fullName = _speakerName[i];
  speakers[_speakerAddress[i]].talksId.push(totalTalks);

  talks[totalTalks].speakers.push(_speakerAddress[i]);
 }

AddTalkEvent(totalTalks,_title,_startTime,_endTime);

}


function getNumberOfTalks() public constant returns (uint) {
  return totalTalks;
}

  // function addTalk(string _title,
  //    string _location,
  //    uint _startTime,
  //    uint _endTime,
  //    address _speakerAddress,
  //    string _speakerName)public onlyOwner {
     

  //    // if (msg.sender != owner) {
  //    //   return;
  //    // } //because we put the modifiers

  //    title = _title;
  //    location = _location;
  //    startTime = _startTime;
  //    endTime = _endTime;
  //    speakerAddress = _speakerAddress;
  //    speakerName = _speakerName; 




  //    AddTalkEvent(title,startTime,endTime);
  // }  
//this function is also works
// function getTalk(address new_address)restricted {
//     Conference upgraded = Conference(new_address);
//     upgraded.addTalk(title,location,startTime,endTime,speakerAddress,speakerName);
// }

//   function getTalk() public constant returns (
//    string _title,
//    string _location,
//    uint _startTime,
//    uint _endTime,
//    address _speakerAddress,
//    string _speakerName ) {
//     return (title,location,startTime,endTime,speakerAddress,speakerName);
// }

// get an active talk and its speakers based on the talk id
function getTalk(uint _talkId) public constant returns (
 string _title,
 string _location,
 uint _startTime,
 uint _endTime,
 address[] _speakerAddress,
 bytes32[] _speakerName
  ) {
  //ensure we have one talk related to this id
  require(bytes(talks[_talkId].title).length > 0);

  // keep only active talks
  require(talks[_talkId].cancelled == false);

  // fetch the talks
  Talk memory talk = talks[_talkId];

  // prepare the list of speakers

  address[] memory speakerAddress = new address[](talk.speakers.length);
  bytes32[] memory speakerName = new bytes32[](talk.speakers.length);

// retrieve the list of speakers
for(uint i = 0;i<talk.speakers.length; i++){
  Speaker memory speaker = speakers[talk.speakers[i]];

  speakerAddress[i] = speaker.account;
  speakerName[i] = speaker.fullName;
}

return (talk.title,talk.location,talk.startTime,talk.endTime,speakerAddress,speakerName);

}

function getTalks(bool onlyCanceled) public constant returns(uint[]_talkId) {
  // we check there is atleast one talk 
  require(totalTalks > 0);
  //prepare the list of talks
  uint[] memory allTalksIds =  new uint[](totalTalks);

  uint numberOfTalks = 0 ;
  for(uint i=1;i <= totalTalks; i++){
    if(talks[i].cancelled == onlyCanceled) {
  allTalksIds[numberOfTalks] = i;
  numberOfTalks++;
    }
  }
  //any talks 
  if (numberOfTalks == totalTalks) {
    //no cancelled talks
    return allTalksIds;
  }
  //shrink the array by removing gaps
  uint[] memory talksId = new uint[](numberOfTalks);

  for(i=0;i < numberOfTalks; i++){
    talksId[i] = allTalksIds[i];
  }

  return talksId;
}


function register(string _fullName) public payable {
  //the price to pay must be the same as the registration price
  require(msg.value == REGISTRATION_PRICE);

  //not already registered
 require(msg.sender != attendeeAddress);

 //register the attendee
 attendeeAddress = msg.sender;
 attendeeName = _fullName;
 RegisterEvent(attendeeAddress,attendeeName);

}

//check if an attendee is registered
//retrns true if the attendee is registered

function isRegistered(address _account) public constant returns (bool){
  if ((_account != attendeeAddress) || (_account == 0x0)){
    //not registered or no registration yet
    return false;
  }

  return true;
} 

}
  

