class Executable
	def initialize(db, sql)
		@db = db
		@sql = sql
	end

	def execute
		@db.do @sql
	end

	def get_sql
		@sql
	end
end