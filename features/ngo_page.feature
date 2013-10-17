Feature: NGO Page

	In order to make my contribution process way easier
	As a contributor
	I want to have all data about the NGO that I wanna help in a single place
	
	Background:
		Given I am a contributor
		And I access a NGO's profile page
	
	Scenario: NGO's information
		Then I must see a name, a description, a phone number and a website link of that NGO

	Scenario: NGO's billboard
		Then I must see their billboard with their bills sorted, by default, by due date