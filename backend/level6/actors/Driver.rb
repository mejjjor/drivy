class Driver < Actor
	def initialize
		super(self.class.name.downcase,"debit")
	end

	def getAmount(rental)
		return rental.price + rental.options['deductible_reduction']
	end
end