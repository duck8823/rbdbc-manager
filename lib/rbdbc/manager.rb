$:.unshift(File.dirname(File.expand_path(__FILE__)) + '/../')
require 'rbdbc/executable'
require 'rbdbc/fromcase'
require 'dbi'

class Manager
	def initialize(driver, datasource, user, password)
		@db = DBI.connect("dbi:#{driver}:#{datasource}", user, password)
	end

	def from(entity)
		FromCase.new(@db, entity)
	end

	def drop(entity)
		Executable.new(@db, "DROP TABLE IF EXISTS #{entity.to_s}")
	end

	def create(entity)
		columns = []
		entity.members.each do |column|
			type = entity[column].name
			case type
				when Integer.name then
					type = 'INTEGER'
				when String.name then
					type = 'TEXT'
				when TrueClass.name, FalseClass.name then
					type = 'BOOLEAN'
				else
					raise Exception.new('次の型は利用できません: %s' % type)
			end
			columns.push '%s %s' % [column.to_s.gsub(/^:/, ''), type]
		end
		Executable.new(@db, 'CREATE TABLE %s (%s)' % [entity.class, columns.join(', ')])
	end

	def insert(data)
		 Executable.new(@db, 'INSERT INTO %s %s' % [data.class, self.class.send(:create_sentence, data)])
	end

	def self.create_sentence(data)
		columns = []
		values = []
		data.members.each do |column|
			value = data[column]
			unless [Fixnum, Integer, String, TrueClass, FalseClass].include? value.class
				raise Exception.new('次の型は対応していません. %s (%s)' % [column, value.class.name])
			end
			columns.push column.to_s.gsub /^:/, ''
			values.push "'%s'" % (data[column].nil? ? '' : data[column].to_s)
		end
		'(%s) VALUES (%s)' % [columns.join(', '), values.join(', ')]
	end
	private_class_method :create_sentence

end