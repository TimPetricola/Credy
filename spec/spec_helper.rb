require 'rubygems'
require 'bundler/setup'

require 'credy'

def silent
  _stdout = $stdout
  $stdout = mock = StringIO.new
  begin
    yield
  ensure
    $stdout = _stdout
  end
end

RSpec.configure do |config|
  config.mock_with :rspec

  config.before :each do
    Credy::CreditCard.any_instance.stub(:colorize) { self }
  end
end
