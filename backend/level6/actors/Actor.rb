class Actor
	attr_reader :name
	attr_reader :type

	def initialize(name,type)
		@name = name
		@type = type
	end

	def getOppositeType
		if @type == 'credit'
			return 'debit'
		else
			return 'credit'
		end
	end

	def getDiff(rental, oldRental)
		outpput = {}
		outpput['who'] = name
		diff = self.getAmount(oldRental) - self.getAmount(rental)
		
		type = @type
		if diff > 0
			type = getOppositeType
		end
		
		return {"who"=>name, "type"=>type, "amount"=>diff.abs}
	end

end