Feature: Index as Table

  Viewing resources as a table on the index page

  Scenario: Viewing the default table with no resources
    Given an index configuration of:
      """
        ActiveAdmin.register Post
      """
    Then I should see a sortable table header with "ID"
    And I should see a sortable table header with "Title"

  Scenario: Viewing the default table with a resource
    Given a post with the title "Hello World" exists
    And an index configuration of:
      """
        ActiveAdmin.register Post
      """
    Then I should see "Hello World"
    Then I should see nicely formatted datetimes
    And I should see a link to "View"
    And I should see a link to "Edit"
    And I should see a link to "Delete"

  Scenario: Customizing the columns with symbols
    Given a post with the title "Hello World" and body "From the body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index do |i|
          i.column :title
          i.column :body
        end
      end
      """
    Then I should see a sortable table header with "Title"
    And I should see a sortable table header with "Body"
    And I should see "Hello World"
    And I should see "From the body"

  Scenario: Customizing the columns with a block
    Given a post with the title "Hello World" and body "From the body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index do |i|
          i.column("My Title") do |post|
            post.title
          end
          i.column("My Body") do |post|
            post.body
          end
        end
      end
      """
    Then I should see a table header with "My Title"
    And I should see a table header with "My Body"
    And I should see "Hello World"
    And I should see "From the body"

  Scenario: Showing and Hiding columns based on an if block at runtime
    Given a post with the title "Hello World" and body "From the body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index do |i|
          i.column :title, :if => proc{ true }
          i.column :body, :if => proc { false }
        end
      end
      """
    Then I should see a sortable table header with "Title"
    And I should not see a table header with "Body"
    And I should see "Hello World"
    And I should not see "From the body"