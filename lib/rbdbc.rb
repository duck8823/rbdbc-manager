require 'rbdbc/version'
require 'rbdbc/manager'
require 'rbdbc/where'

module Rbdbc
	def self.connect(driver, datasource, user=nil, password=nil)
		return Manager.new(driver, datasource, user, password)
	end
end
