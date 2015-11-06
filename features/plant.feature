@init
Feature: Manage plants
    In order to work with a garden calender
    A visitor
    Should be able to manage his plants

  Background:
    before(true) do
      puts "this is done before every scenario."
    end

  @wip
  Scenario: Creates a new plant
      Given I am a new, authenticated user
        And I am on the new plant page
        And I fill in "plant[name]" with "Flammenblume"
        And I fill in "plant[desc]" with "A nice plant"

       When I press "Pflanze speichern"

       Then page should have notice message "Pflanze wurde erfolgreich gespeichert."

  Scenario: Edits an existing plant
      When I test productbla
     # Given I am a new, authenticated user
        And I am on the edit plant page
        And I fill in "plant[desc]" with "Dies ist eine schöne Blume."

        When I press "Pflanze speichern"

        Then page should have notice message "Pflanze wurde erfolgreich gespeichert."
         And I should see "Dies ist eine schöne Blume."

  Scenario: Lists own plants
      Given a user Bob has an account
        And Bob creates 3 plants

        When I go to plants index page

        Then I should see 3 plants
