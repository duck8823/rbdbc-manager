$:.unshift(File.dirname(File.expand_path(__FILE__)) + '/../lib/')
require 'minitest/autorun'

require 'rbdbc'

Test = Struct.new(:id, :name)

class FromCaseTest < Minitest::Test

	def test_list
		manager = Rbdbc.connect('SQLite3', 'test.db')
		manager.drop(Test).execute

		manager.create(Test.new(id=Integer, name=String)).execute

		manager.insert(Test.new(1, 'name_1')).execute
		manager.insert(Test.new(2, 'name_2')).execute

		actual = manager.from(Test).list
		assert_equal [Test.new(id=1, name='name_1'), Test.new(id=2, name='name_2')], actual

		assert_raises(Exception) {
			manager.from(Test).where(Where.new('id', Array.new([]), Operator::EQUAL)).execute
		}
	end

	def test_single_result
		manager = Rbdbc.connect('SQLite3', 'test.db')
		manager.drop(Test).execute

		manager.create(Test.new(id=Integer, name=String)).execute

		manager.insert(Test.new(1, 'name_1')).execute
		manager.insert(Test.new(2, 'name_2')).execute

		actual = manager.from(Test).where(Where.new('id', 1, Operator::EQUAL)).single_result
		expect = Test.new(id=1, name='name_1')
		assert_equal expect, actual

		assert_raises(Exception) {
			manager.from(Test).single_result
		}
	end

	def test_delete
		manager = Rbdbc.connect('SQLite3', 'test.db')
		manager.drop(Test).execute

		manager.create(Test.new(id=Integer, name=String)).execute

		manager.insert(Test.new(1, 'name_1')).execute
		manager.insert(Test.new(2, 'name_2')).execute

		manager.from(Test).where(Where.new('id', 1, Operator::EQUAL)).delete.execute
		actual = manager.from(Test).single_result
		expect = Test.new(id=2, name='name_2')
		assert_equal expect, actual
	end

end