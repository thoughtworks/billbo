Feature: Upload receipt

	After paying a bill, users can upload a receipt (even whether the bill is reserved or opened)

	Background:
		Given that there are 2 NGOs subscribed with 3 bills on each one

	Scenario Outline: Analyse whether the users can see the upload receipt buttons or not
		Given I am a contributor that is <Status>
		When I access a NGO's profile page
		Then I <Result> that allow me to upload receipts

		Examples:
			| Status        | Result                |
			| logged in     | can see the buttons   |
			| not logged in | can't see the buttons |