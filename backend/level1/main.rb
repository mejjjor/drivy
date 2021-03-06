require 'json'
require 'date'

data = JSON.parse(File.read('data.json'))
rentals = []

def calculateRentalDays(rental)
	return (Date.parse(rental['end_date'])-Date.parse(rental['start_date'])+1).to_i
end

def calculatePrice(rental, cars)
	car = cars.select{|car| car['id'] == rental['car_id']}[0]
	return car['price_per_km'] * rental['distance'] + calculateRentalDays(rental) * car['price_per_day']
end

for rental in data['rentals']
	rentals.push({"id"=>rental['id'],"price"=> calculatePrice(rental, data['cars'])})
end

File.open("output.json",'w') do |f|
	f.write({"rentals"=>rentals}.to_json)
	f.close
end
