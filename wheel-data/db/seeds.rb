# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
def generate_sku(number)
  charset = Array('A'..'Z') + Array('a'..'z')
  Array.new(number) { charset.sample }.join
end

honda = Manufacturer.create(name: 'Honda')
subaru = Manufacturer.create(name: 'Subaru')
toyota = Manufacturer.create(name: 'Toyota')
vw = Manufacturer.create(name: 'Volkswagen')

standard_trim_data = { bolt_pattern: '5x113', min_offset: 20, max_offset: 50, min_width: 7, max_width: 9, min_diameter: 15, max_diameter: 20 }
civic = Car.create(manufacturer: honda, name: 'Civic', year: '2020')
civic.trims.create(standard_trim_data.merge(name: 'SI', min_diameter: 17, max_width: 8.5, max_offset: 43, min_offset: 35))
civic.trims.create(standard_trim_data.merge(name: 'EX', min_diameter: 17, max_diameter: 17, max_offset: 43, max_width: 8.5))
civic.trims.create(standard_trim_data.merge(name: 'Type R',min_diameter: 18, min_width:8, max_width: 9.5, min_offset: 30, max_offset: 45))
gti = Car.create(manufacturer: vw, name: 'Golf GTI', year: 2018)
gti.trims.create(standard_trim_data.merge(name: 'S', min_diameter: 16, min_width: 6.5, max_width: 8.5, max_offset: 51, min_offset: 34))
gti.trims.create(standard_trim_data.merge(name: 'SE', min_diameter: 17, min_width: 7, max_width: 8.5, max_offset: 50, min_offset: 34))
gti.trims.create(standard_trim_data.merge(name: 'Autobahn', min_diameter: 18, min_width: 7, max_width: 8.5, max_offset: 50, min_offset: 34))
wv1 = WheelVendor.create(name: 'Wheel Vendor 1')
wv2 = WheelVendor.create(name: 'Wheel Vendor 2')
finishes = ['black', 'alloy', 'brushed steel', 'matte']
makers = [ 'msa', 'niche', 'kmc', 'level 8', 'rotiform', 'victor equipment', 'zbroz']

(6.5..9).step(0.5).each do |width|
  (16..20).each do |diameter|
    10.times do 
       ['5x113', '5x112', '4x100'].each do |bolt_pattern|
         vendor_id = rand 100..10000
         offset = (30..51).to_a.sample
         Wheel.create(wheel_vendor: [wv1, wv2].sample, vendor_id: vendor_id, bolt_pattern: bolt_pattern, width: width, offset: offset, diameter: diameter, finish: finishes.sample, brand: makers.sample, vendor_sku: generate_sku(8))
      end
    end
  end
end

