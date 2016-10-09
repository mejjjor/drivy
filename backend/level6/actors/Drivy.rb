class Drivy < Actor
	def initialize
		super(self.class.name.downcase,"credit")
	end

	def getAmount(rental)
		return rental.commission['drivy_fee'] + rental.options['deductible_reduction']
	end
end