$:.unshift(File.dirname(File.expand_path(__FILE__)) + '/../lib/')
require 'minitest/autorun'

require 'rbdbc'


class RbdbcTest < Minitest::Test
	def test_connect
		manager = Rbdbc.connect('SQLite3', 'test.db')
		assert_instance_of Manager, manager
	end
end