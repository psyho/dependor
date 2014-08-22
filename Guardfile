guard :rspec, cmd: 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { "spec" }
  watch('spec/spec_helper.rb') { "spec" }
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
end
