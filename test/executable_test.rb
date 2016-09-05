$:.unshift(File.dirname(File.expand_path(__FILE__)) + '/../lib/')
require 'minitest/autorun'

require 'rbdbc'

Fail = Struct.new(:id, :fail)
Success = Struct.new(:id, :name)

class ExecutableTest < Minitest::Test

	def test_execute
		manager = Rbdbc.connect('SQLite3', 'test.db')

		assert_raises(Exception) {
			manager.create(Fail.new(id=Integer, fail=Array)).execute
		}

		manager.drop(Success).execute
		manager.create(Success.new(id=Integer, name=String)).execute

		assert_raises(Exception) {
			manager.create(Success.new(id=Integer, name=String)).execute
		}
	end

	def test_get_sql
		manager = Rbdbc.connect('SQLite3', 'test.db')

		actual = manager.create(Success.new(id=Integer, name=String)).get_sql
		expect = 'CREATE TABLE Success (id INTEGER, name TEXT)'
		assert_equal expect, actual
	end

end