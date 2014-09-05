Given(/^dependor is required using:$/) do |string|
  example_builder.add_require(string)
end

Given(/^dependor is required with core extensions$/) do
  example_builder.add_require("require 'dependor'")
  example_builder.add_require("require 'dependor/core_ext'")
end

Given(/^a class is defined:$/) do |string|
  example_builder.add_class(string)
end

When(/^I run:$/) do |string|
  example_builder.add_run_block(string)
end

Then(/^the output should be:$/) do |string|
  assert_exact_output(string, example_builder.output)
end
