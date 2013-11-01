Feature: Homepage

	In order to have easy access to the NGOs subscribed on Billbo
	As a contributor
	I want to have links to the NGOs' profiles on the homepage (each one with the name, a photo and the philosophy of the NGO)
	
	Background:
		Given that there are 3 NGOs subscribed with 0 bill on each one
		And I am a contributor that is not logged in
		When I open the homepage

	Scenario: NGOs' links with the most important information (name, photo and philosophy)
		Then I must see the NGOs' links with name, photo and philosophy of each NGO
	
	Scenario: Link to NGO's profile
		When I click on a link of the NGO
		Then I must be redirected to the NGO's profile