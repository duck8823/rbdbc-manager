$:.unshift(File.dirname(File.expand_path(__FILE__)) + '/../')
require 'rbdbc/executable'

class FromCase
	def initialize(db, entity)
		@db = db
		@entity = entity
		@where = Where.new(nil, nil, nil)
	end

	def where(where)
		@where = where
		self
	end

	def list
		result = []

		sth = @db.execute('SELECT %s FROM %s %s' % [@entity.members.join(', '), @entity.name, @where])
		sth.fetch do |row|
			result.push(@entity.new(*row.to_a))
		end
		result
	end

	def single_result
		result = self.list
		if result.length > 1
			raise Exception.new('結果が一意でありません.')
		end
		result[0]
	end

	def delete
		Executable.new(@db, 'DELETE FROM %s %s' % [@entity.name, @where])
	end

end