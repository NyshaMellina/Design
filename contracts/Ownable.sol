pragma solidity ^0.4.15;

//solidty support multiple inheritance

 

contract Ownable {
	//state variable
	address owner;

	//Modifiers
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	//constructor
	function Ownable() {
		owner = msg.sender;
	}
} 