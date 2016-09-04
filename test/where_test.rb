$:.unshift(File.dirname(File.expand_path(__FILE__)) + '/../lib/')
require 'minitest/autorun'

require 'sqlite3'
require 'rbdbc'


class WhereTest < Minitest::Test

	def test_new
		where = Where.new(nil, nil, nil)
		assert_instance_of Where, where
	end

	def test_to_s
		where = Where.new(nil, 1, Operator::EQUAL)
		assert_raises(Exception) {
			where.to_s
		}

		where = Where.new('id', nil, Operator::EQUAL)
		assert_raises(Exception) {
			where.to_s
		}

		where = Where.new(nil, nil, Operator::EQUAL)
		assert_raises(Exception) {
			where.to_s
		}

		where = Where.new('id', Array.new([]), Operator::EQUAL)
		assert_raises(Exception) {
			where.to_s
		}

		except = "WHERE name LIKE '%name%'"
		actual = Where.new('name', 'name', Operator::LIKE).to_s
		assert_equal except, actual
	end

	def test_operator
		assert_equal '=', Operator::EQUAL
		assert_equal '<>', Operator::NOT_EQUAL
		assert_equal 'LIKE', Operator::LIKE
	end

end