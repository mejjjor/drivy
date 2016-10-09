require 'json'
require 'date'
require './Car.rb'
require './Rental.rb'

data = JSON.parse(File.read('data.json'))
cars = []
rentals = []
output = []

for car in data['cars']
	cars.push(Car.new(car))
end

for rental in data['rentals']
	rentals.push(Rental.new(rental, cars.select{|car| car.id == rental['car_id']}[0]))
end

for rental in rentals
	output.push({"id" => rental.id, "price" => rental.calculatePrice, "commission" => rental.calculateCommissions})
end

File.open("output.json",'w') do |f|
	f.write({"rentals"=>output}.to_json)
	f.close
end