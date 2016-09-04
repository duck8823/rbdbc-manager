$:.unshift(File.dirname(File.expand_path(__FILE__)) + '/../lib/')
require 'minitest/autorun'

require 'rbdbc'

Test = Struct.new(:id, :name)

class ManagerTest < Minitest::Test

	def test_connection
		manager = Rbdbc.connect('SQLite3', 'test.db')
		assert_instance_of Manager, manager
	end

	def test_create
		manager = Rbdbc.connect('SQLite3', 'test.db')
		manager.drop(Test).execute
		manager.create(Test.new(Integer, String)).execute

		db = manager.instance_variable_get('@db')
		sth = db.execute('PRAGMA TABLE_INFO(test)')

		actual = {}
		sth.fetch_array do |row|
			actual[row[1]] = row[2]
		end

		assert_equal({'id'=>'INTEGER', 'name'=>'TEXT'}, actual)

		assert_raises(Exception) {
			manager.create(Fail.new(Array)).execute
		}

	end

	def test_drop
		manager = Rbdbc.connect('SQLite3', 'test.db')
		manager.drop(Test).execute
		manager.create(Test.new(Integer, String)).execute

		manager.drop(Test).execute

		db = manager.instance_variable_get('@db')
		sth = db.execute('PRAGMA TABLE_INFO(Test)')
		actual = sth.fetch_array

		assert_nil actual, 'カラムが存在します.'
	end

	def test_insert
		manager = Rbdbc.connect('SQLite3', 'test.db')
		manager.drop(Test).execute
		manager.create(Test.new(Integer, String)).execute

		manager.insert(Test.new(1, 'name_1')).execute
		manager.insert(Test.new(2, 'name_2')).execute

		expect = [[1, 'name_1'], [2, 'name_2']]

		db = manager.instance_variable_get('@db')
		sth = db.execute('SELECT id, name FROM Test')
		actual = []
		sth.fetch_array do |row|
			actual.push row
		end

		assert_equal expect, actual, 'データが一致しません.'
	end

	def test_create_sentence
		actual = Manager.send(:create_sentence, Test.new(1, 'name_1'))
		assert_equal "(id, name) VALUES ('1', 'name_1')", actual

		assert_raises(Exception) {
			Manager.send(:create_sentence, Fail.new(Array.new([])))
		}
	end

end