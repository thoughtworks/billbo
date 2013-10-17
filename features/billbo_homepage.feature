Feature: Billbo Homepage

	In order to have easy access to the NGOs subscribed on Billbo
	As a contributor
	I want to have links to the NGOs' profiles on the homepage (each one with the name, a photo and the philosophy of the NGO)
	
	Background:
		Given I am a contributor
		And I open the home page
	
	Scenario: NGOs' links with the most important information (name, photo and philosophy)
		Then I must see the NGOs' links with name, photo and philosophy of each NGO
	
	Scenario: Link to NGO's profile
		When I click on a link of a NGO
		Then I must be redirected to the NGO's profile