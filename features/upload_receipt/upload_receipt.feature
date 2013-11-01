Feature: Upload receipt

	After paying a bill, users can upload a receipt (even whether the bill is reserved or opened)

	Background:
		Given that there are 2 NGOs subscribed with 3 bills on each one
		
	Scenario: Not logged users can't see the buttons that allow them to upload receipts
		Given I am a contributor that is not logged in
		When I access a NGO's profile page
		Then I can't see the buttons that allow me to upload receipts