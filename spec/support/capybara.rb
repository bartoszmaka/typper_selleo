require_relative 'locators/find_table_row'

Capybara::Session.include FindTableRow
Capybara::Node::Simple.include FindTableRow
