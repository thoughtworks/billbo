Feature: Reserve bill

	This is one of the most important features of the plataform. NGOs can put their bills on billboards
	and people around the world can contribute paying these bills.

	Background:
		Given that there are 3 NGOs subscribed with 10 bills on each one

	@wip @javascript
	Scenario: Only one contributor can reserve a bill at once
		Given I am a contributor that is logged in
		And I access a NGO's profile page
		When I try to reserve an "opened" bill
		Then that bill becomes "reserved"
		And no other user can reserve it
		
	Scenario: Not logged users can't see the buttons that allow them to reserve opened bills
		Given I am a contributor that is not logged in
		When I access a NGO's profile page
		Then I can't see the buttons that allow me to reserve bills