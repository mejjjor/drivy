class Owner < Actor
	def initialize
		super(self.class.name.downcase,"credit")
	end

	def getAmount(rental)
		return (rental.price * rental.getPercentageOwner).to_i
	end
end