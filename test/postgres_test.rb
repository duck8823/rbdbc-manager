$:.unshift(File.dirname(File.expand_path(__FILE__)) + '/../lib/')
require 'minitest/autorun'

require 'rbdbc'

Hoge = Struct.new(:id, :name, :flg)

class PostgresTest < Minitest::Test

	def test_postgres
		manager = Rbdbc.connect('Pg', 'dbname=test;host=localhost', user='postgres')

		manager.drop(Hoge).execute

		manager.create(Hoge.new(id=Integer, name=String, flg=TrueClass)).execute

		manager.insert(Hoge.new(1, 'name_1', true)).execute
		manager.insert(Hoge.new(2, 'name_2', false)).execute

		actual = manager.from(Hoge).list
		assert_equal [Hoge.new(id=1, name='name_1', flg=true), Hoge.new(id=2, name='name_2', flg=false)], actual
	end

end