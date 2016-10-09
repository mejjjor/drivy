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

#init actors
for actor in ACTORS
	actor = Object.const_get(actor).new
	actors.push(actor)
end

#init cars
for car in data['cars']
	cars.push(Car.new(car))
end

#init rentals
for rental in data['rentals']
	car = cars.select{|car| car.id == rental['car_id']}[0]
	if car == nil
		raise "Inconsistent data, no car with id: #{rental['car_id']}"
	end 
	rentals.push(Rental.new(rental,car))
end

#build output
for rentalModif in data['rental_modifications']
	rental = rentals.select{|rental| rental.id == rentalModif['rental_id']}[0]
	rental.computeModif(rentalModif)

	data = {}
	data['id'] = rentalModif['id']
	data['rental_id'] = rentalModif['rental_id']
	data['action'] = []
	for actor in actors
		data['action'].push(actor.getDiff(rental, rental.previousRental))
	end
	output.push(data)
end

File.open("output.json",'w') do |f|
	f.write({"rental_modifications"=>output}.to_json)
	f.close
end