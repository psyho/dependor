require 'aruba/cucumber'
require 'aruba/jruby'

Before do
  @aruba_timeout_seconds = 60
end

Before do |scenario|
  @scenario = scenario
end

if RUBY_PLATFORM == 'java' && ENV['TRAVIS']
  Aruba.configure do |config|
    config.before_cmd do
      set_env('JAVA_OPTS', "#{ENV['JAVA_OPTS']} -d64")
    end
  end
end
