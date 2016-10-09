require 'json'
require 'date'
require './Car.rb'
require './Rental.rb'
Dir["./actors/*.rb"].each {|file| require file }

data = JSON.parse(File.read('data.json'))
cars = []
rentals = []
output = []
actors = []

ACTORS = ['Driver','Owner','Insurance','Assistance','Drivy']

for actor in ACTORS
	actor = Object.const_get(actor).new
	actors.push(actor)
end

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
	output.push({"id" => rental.id, "actions" => rental.getActions(actors)})
end

File.open("output.json",'w') do |f|
	f.write({"rentals"=>output}.to_json)
	f.close
end