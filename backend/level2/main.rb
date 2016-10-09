require 'json'
require 'date'

data = JSON.parse(File.read('data.json'))
rentals = []

def calculateRentalDays(rental)
	return (Date.parse(rental['end_date'])-Date.parse(rental['start_date'])+1).to_i
end

def calculateDaysPrice(nbDays,price_per_day)
	price = 0
	(1..nbDays).each do |i|
		case i
		when 1 
			price += price_per_day
		when 2..4
			price += price_per_day*0.9
		when 5..10
			price += price_per_day*0.7
		else
			price += price_per_day*0.5
		end
	end
	return price.to_i
end

def calculatePrice(rental, cars)
	car = cars.select{|car| car['id'] == rental['car_id']}[0]
	daysPrice = calculateDaysPrice(calculateRentalDays(rental), car['price_per_day'])
	return car['price_per_km'] * rental['distance'] + daysPrice
end

for rental in data['rentals']
	rentals.push({"id"=>rental['id'],"price"=> calculatePrice(rental, data['cars'])})
end

File.open("output.json",'w') do |f|
	f.write({"rentals"=>rentals}.to_json)
	f.close
end
