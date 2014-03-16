require 'rubygems'
require 'bundler/setup'

require 'credy'

def silent
  _stdout = $stdout
  $stdout = StringIO.new
  begin
    yield
  ensure
    $stdout = _stdout
  end
end

# Don't colorize strings in test environment
class String
  def colorize(color_code)
    self
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
