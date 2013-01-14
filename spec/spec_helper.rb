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
  
end