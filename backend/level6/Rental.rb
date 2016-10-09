class Rental
	attr_reader :id
	attr_reader :car
	attr_reader :start_date
	attr_reader :end_date
	attr_reader :distance
	attr_reader :deductible_reduction

	attr_reader :rentalDays
	attr_reader :daysPrice
	attr_reader :price
	attr_reader :commission
	attr_reader :options

	attr_reader :previousRental

	DEDUCTIBLE_REDUCTION_CHARGE = 400

	REDUCTION_AFTER_1_DAY = 0.9
	REDUCTION_AFTER_4_DAYS = 0.7
	REDUCTION_AFTER_10_DAYS = 0.5

	PERCENTAGE_INSURANCE = 0.5
	ASSISTANCE_FEE = 100

	PERCENTAGE_COMMISSION = 0.3

	def compute
		@rentalDays = calculateRentalDays
		@daysPrice = calculateDaysPrice
		@price = calculatePrice
		@commission = calculateCommission
		@options = calculateOptions
	end

	def initialize(rental, car)
		@id = rental['id']
		@car = car
		@start_date = rental['start_date']
		@end_date = rental['end_date']
		@distance = rental['distance']
		@deductible_reduction = rental['deductible_reduction']
		compute
	end

	def calculateRentalDays
		return (Date.parse(end_date)-Date.parse(start_date)+1).to_i
	end

	def calculateDaysPrice
		price = 0
		(1..rentalDays).each do |i|
			case i
			when 1 
				price += car.price_per_day
			when 2..4
				price += car.price_per_day*REDUCTION_AFTER_1_DAY
			when 5..10
				price += car.price_per_day*REDUCTION_AFTER_4_DAYS
			else
				price += car.price_per_day*REDUCTION_AFTER_10_DAYS
			end
		end
		return price.to_i
	end

	def calculatePrice
		return car.price_per_km * distance + daysPrice
	end

	def calculateCommission
		fees = price * PERCENTAGE_COMMISSION
		output = {"insurance_fee" => (fees*PERCENTAGE_INSURANCE).to_i}
		output["assistance_fee"] = ASSISTANCE_FEE*rentalDays
		output["drivy_fee"] = (fees - output['insurance_fee'] - output['assistance_fee']).to_i
		return output
	end

	def calculateOptions
		output = {}
		if deductible_reduction
			output['deductible_reduction'] = rentalDays*DEDUCTIBLE_REDUCTION_CHARGE
		else
			output['deductible_reduction'] = 0
		end
		return output
	end

	def getPercentageOwner
		return 1 - PERCENTAGE_COMMISSION
	end

	def computeModif(rentalModif)
		@previousRental = self.clone
		if rentalModif['end_date'] != nil
			@end_date = rentalModif['end_date']
		end
		if rentalModif['start_date'] != nil
			@start_date = rentalModif['start_date']
		end
		if rentalModif['distance'] != nil
			@distance = rentalModif['distance']
		end
		compute
	end
end