$:.unshift(File.dirname(File.expand_path(__FILE__)) + '/../')
require 'rbdbc/executable'

class Where
	def initialize(column, value, operator)
		@column = column
		@value = value
		@operator = operator
	end

	def to_s
		if @column.nil? && @value.nil? && @operator.nil?
			return ''
		elsif (!@column.nil? && @value.nil?) || (@column.nil? && !@value.nil?) || (@column.nil? && @value.nil? && !@operator.nil?)
			raise Exception.new('error: {column=%s, value=%s, operator=%s}' % [@column, @value, @operator])
		end
		unless [Fixnum, Integer, String, TrueClass, FalseClass].include?(@value.class)
			raise Exception.new('次の型は対応していません. %s (%s)' % [@column, @value.class.name])
		end
		if @operator == Operator::LIKE
			@value = '%' + @value.to_s + '%'
		end
		"WHERE %s %s '%s'" % [@column, @operator, @value]
	end
end

module Operator
	EQUAL = '='
	NOT_EQUAL = '<>'
	LIKE = 'LIKE'
end