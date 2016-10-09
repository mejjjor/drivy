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
	actors.push(Object.const_get(actor).new)
end

#init cars
for car in data['cars']
	cars.push(Car.new(car))
end

#init rentals
data['rentals'].sort! {|x,y| x['car_id'] <=> y['car_id']}
cars.sort! {|x,y| x['id'] <=> y['id']}
carIndex = 0
car = cars[carIndex]
for rental in data['rentals']
	while car.id != rental['car_id']
		carIndex += 1
		if carIndex == cars.length
			raise "Inconsistent data, no car with id: #{rental['car_id']} from rental id=#{rental['id']}"
		end
		car = cars[carIndex]
	end

	rentals.push(Rental.new(rental,car))
end

#build output
data['rental_modifications'].sort! {|x,y| x['rental_id'] <=> y['rental_id']}
rentalIndex = 0
rental = rentals[rentalIndex]
for rentalModif in data['rental_modifications']
	while rental.id != rentalModif['rental_id']
		rentalIndex += 1
		if rentalIndex == rentals.length
			raise "Inconsistent data, no rental with id: #{rentalModif['rental_id']} from rental_modification id=#{rentalModif['id']}"
		end
		rental = rentals[rentalIndex]
	end

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