class Car
	attr_reader :id
	attr_reader :price_per_day
	attr_reader :price_per_km

	def initialize(car)
		@id = car['id']
		@price_per_day = car['price_per_day']
		@price_per_km = car['price_per_km']
	end

end