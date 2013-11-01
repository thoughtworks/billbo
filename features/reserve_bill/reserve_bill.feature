Feature: Reserve bill

	This is one of the most important features of the plataform. NGOs can put their bills on billboards
	and people around the world can contribute paying these bills.

	Background:
		Given that there are 3 NGOs subscribed with 4 opened bills and 6 reserved bills on each one

	@javascript
	Scenario: Only one contributor can reserve a bill at once
		Given I am a contributor that is logged in
		And I access a NGO's profile page
		When I try to reserve an "opened" bill
		Then that bill becomes "reserved"
		And no other user can reserve it

	@wip
	Scenario Outline: Analyse whether the users can see the reserve bills buttons or not
		Given I am a contributor that is <User status>
		When I access a NGO's profile page
		Then I <Result> that allow me to reserve "<Bills status>" bills

		Examples: Logged in users
			| User status   | Result                | Bills status |
			| logged in     | can see the buttons   | opened       |
			| logged in     | can't see the buttons | reserved     |

		Examples: Not logged in users
			| User status   | Result                | Bills status |
			| not logged in | can't see the buttons | opened			 |
			| not logged in | can't see the buttons | reserved		 |