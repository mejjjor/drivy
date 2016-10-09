class Insurance < Actor
	def initialize
		super(self.class.name.downcase,"credit")
	end

	def getAmount(rental)
		return rental.commission['insurance_fee']
	end
end