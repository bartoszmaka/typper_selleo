require 'rspec/expectations'
require 'pry'

RSpec::Matchers.define :have_table_row do |*expected|
  match do |page|
    @page_headers = page.all('thead > tr > th').map(&:text)
    @cells_with_indexes = parsed_input(expected)
    if found_more_than_one_table?(page)
      @failure_message = 'Ambigous match, there is more than one table'
      return false
    elsif get_missing_headers(expected).any?
      @failure_message = "Could not find columns: #{get_missing_headers(expected).join(', ')}"
      return false
    elsif !row_found?(page)
      @failure_message = "Row with #{formatted_missing_row(expected)} not found"
      return false
    end
    true
  end

  failure_message do
    @failure_message
  end

  def formatted_missing_row(expected)
    expected = expected.first if expected.count == 1
    expected.map do |header_value|
      header_value.is_a?(Array) ? header_value.join(': ') : header_value
    end.join(', ')
  end

  def row_found?(page)
    page.all('tbody > tr').any? do |row|
      @cells_with_indexes.all? do |column_index, cell_expectation|
        cell_data = row.find(:xpath, "./td[#{column_index + 1}]")
        compare(cell_data, cell_expectation)
      end
    end
  end

  def compare(cell_data, cell_expectation)
    return true if cell_data.text == cell_expectation.to_s
    cell_expectation.matches?(cell_data.text) if cell_expectation.respond_to? :matches?
  end

  def parsed_input(expected)
    expected = if expected.first.is_a? Hash
                 expected.first
               else
                 expected.map.with_index { |cell_expectation, index| [index, cell_expectation] }.to_h
               end
    expected.transform_keys do |key|
      key.is_a?(String) ? @page_headers.index(key) : key
    end
  end

  def get_missing_headers(expected)
    expected = expected.first
    return [] unless expected.is_a? Hash
    keys = expected.keys.keep_if { |key| key.is_a? String }
    keys - @page_headers
  end

  def found_more_than_one_table?(page)
    return true if page.all('table').count > 1
  end
end
