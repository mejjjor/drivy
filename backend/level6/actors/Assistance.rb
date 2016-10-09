class Assistance < Actor
	def initialize
		super(self.class.name.downcase,"credit")
	end

	def getAmount(rental)
		return rental.commission['assistance_fee']
	end
end