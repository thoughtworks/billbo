Feature: Bills can only be reserved once

	In order to avoid problems like two people paying the same bill
	As a NGO Admin
	I want to have only one person at a time responsible for each bill

	Background:
		Given that there are 3 NGOs subscribed with 10 bills on each one

	@wip @javascript
	Scenario: Only one contributor can reserve a bill
		Given I am a contributor
		And I am logged in
		And I access a NGO's profile page
		When I try to reserve an "opened" bill
		Then that bill becomes "reserved"
		And no other user can reserve it