require 'test_helper'
require 'simplecov'

if ENV['CI']
	require 'coveralls'
	Coveralls.wear!

	SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[Coveralls::SimpleCov::Formatter]
	SimpleCov.start 'rails' do
		add_filter 'rbdbc/version'
	end
else
	SimpleCov.start 'rails' do
		add_filter 'rbdbc/version'
	end
end