var conference = artifacts.require("./Conference.sol");
 
 //test 
 contract('Conference',function (accounts) {
 	var contractInstance;
 	var registrationPrice = 1.8;
 	var attendee = accounts[1];
 	var attendeeFullName = "Rick DickYard";

 	// first case donot register as attendee sending the wrong value
 	it("should not registered an attendee the wrong value" , function () {
 		return conference.deployed().then(function (instance) {
 			contractInstance = instance;
 			return contractInstance.register(attendeeFullName , {
 				from:attendee,
 				value:web3.toWei(registrationPrice - 0.5,"ether"),
 				gas:500000
 			});
 		}).then(assert.fail)
 		.catch(function (error) {
 			assert(error.message.indexOf('revert') >= 0,"error should be revert");

 		});
 	});
 });