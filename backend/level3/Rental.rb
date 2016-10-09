class Rental
	attr_reader :id
	attr_reader :car
	attr_reader :start_date
	attr_reader :end_date
	attr_reader :distance
	attr_reader :price

	def initialize(rental, car)
		@id = rental['id']
		@car = car
		@start_date = rental['start_date']
		@end_date = rental['end_date']
		@distance = rental['distance']
	end

	def calculateRentalDays
		return (Date.parse(end_date)-Date.parse(start_date)+1).to_i
	end

	def calculateDaysPrice
		price = 0
		(1..calculateRentalDays).each do |i|
			case i
			when 1 
				price += car.price_per_day
			when 2..4
				price += car.price_per_day*0.9
			when 5..10
				price += car.price_per_day*0.7
			else
				price += car.price_per_day*0.5
			end
		end
		return price.to_i
	end

	def calculatePrice
		@price = car.price_per_km * distance + calculateDaysPrice
		return price
	end

	def calculateCommissions
		fees = price * 0.3
		output = {"insurance_fee" => (fees/2).to_i, "assistance_fee" => 100*calculateRentalDays}
		output["drivy_fee"] = (fees - output['insurance_fee'] - output['assistance_fee']).to_i
		return output
	end

end