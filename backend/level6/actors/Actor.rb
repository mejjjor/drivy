class Actor
	attr_reader :name
	attr_reader :type

	def initialize(name,type)
		@name = name
		@type = type
	end

	def getOppositeType
		if type == 'credit'
			return 'debit'
		else
			return 'credit'
		end
	end

end