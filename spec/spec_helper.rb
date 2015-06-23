require 'rubygems'
require 'bundler/setup'

require 'credy'

def silent
  _stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = _stdout
  end
  fake.string
end

# Don't colorize strings in test environment
class String
  def colorize(color_code)
    self
  end
end
