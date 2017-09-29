require 'rspec/expectations'

module FindTableRow
  def find_table_row(*column_expectations)
    TableRowFinder.call(self, *column_expectations)
  end

  class TableRowFinder
    def initialize(page, column_expectations)
      @page = page
      @column_expectations = column_expectations
    end

    def self.call(page, *column_expectations)
      hash_expectations = column_expectations.extract_options!
      new(page, hash_expectations.presence || column_expectations).call
    end

    def call
      verify_table_ambiguity!
      find_row
    end

    private

    attr_reader :page, :column_expectations

    def normalized_column_expectations
      @normalized_column_expectations ||= begin
        if column_expectations.is_a? Array
          column_expectations.each_with_index.each_with_object({}) do |(value, index), result|
            result[index] = value
          end
        else
          ensure_headers_presence!

          column_expectations.transform_keys do |key|
            key.is_a?(String) ? table_header_labels.index(key) : key
          end
        end
      end
    end

    def verify_table_ambiguity!
      if page.all('table').count > 1
        raise Capybara::Ambiguous, 'Ambiguous match, there is more than one table'
      end
    end

    def table_header_labels
      @existing_header_labels ||= page.all('thead > tr > th').map(&:text)
    end

    def ensure_headers_presence!
      expected_header_labels = column_expectations.keys.select{ |v| v.is_a? String }
      missing_headers = expected_header_labels - table_header_labels

      if missing_headers.present?
        raise Capybara::ElementNotFound, "Could not find columns: #{missing_headers.join(', ')}"
      end
    end

    def find_row
      matching_rows = page.all('tbody > tr').find_all do |row|
        normalized_column_expectations.all? do |column_index, expectation|
          cell = row.find(:xpath, "./td[#{column_index + 1}]")
          compare(cell, expectation)
        end
      end

      if matching_rows.count > 1
        raise Capybara::Ambiguous, "Ambiguous match, found #{matching_rows.count} rows"
      elsif matching_rows.empty?
        raise Capybara::ElementNotFound, "Row with #{formatted_expected_attributes} not found"
      else
        matching_rows.first
      end
    end

    def formatted_expected_attributes
      if column_expectations.is_a?(Array)
        column_expectations.join(', ')
      else
        column_expectations.map do |header_name, expected_value|
          "#{header_name}: #{expected_value}"
        end.join(', ')
      end
    end

    def compare(cell, expectation)
      return expectation.matches?(cell) if expectation.respond_to?(:matches?)
      cell.text == expectation.to_s
    end
  end
end
