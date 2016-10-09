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
	car = cars.select{|car| car.id == rental['car_id']}[0]
	if car == nil
		raise "Inconsistent data, no car with id: #{rental['car_id']}"
	end 
	rentals.push(Rental.new(rental,car))
end

for rental in rentals
	output.push({"id" => rental.id, "price" => rental.price,"options" =>rental.options, "commission" => rental.commission})
end

File.open("output.json",'w') do |f|
	f.write({"rentals"=>output}.to_json)
	f.close
end