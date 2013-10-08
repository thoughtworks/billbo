Feature: Delete a bill
	
	Background: 
		Given I am an admin
		And I have 5 bills

	@javascript
	Scenario: delete a bill that is opened
		When I open the home page
		And I select a "opened" bill
		Then I should be able to delete this bill
		