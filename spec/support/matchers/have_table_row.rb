
# @Date:   2017-11-04 13:26:19
# @Last Modified by:   Synion
# @Last Modified time: 2017-11-06 21:43:05
require 'rspec/expectations'

RSpec::Matchers.define :have_table_row do |*expected|
  match do |page|
    begin
      page.find_table_row(*expected)
    rescue => error
      @failure_message = error.message
      return false
    end
  end

  failure_message do
    @failure_message
  end
end
