## Wheel Data

Stated Problem:

At throtl we receive product data, vehicle data and general data from multiple different sources. This presents the problem of how to store the data from the multiple sources while associating them and using their specifications to our advantage. The biggest challenge is wheels. The goal here is to associate unique_vehicle_ids to wheel_products. For a 2018 Subaru WRX’s, all wheel products that have a bolt pattern of 5x113, offset 8, width 6in to 8in and diameter 17in to 19in fit (I’m making this up, it may not actually fit but if you want to look up what actually fits be my guest). In real life products give wheel specifications like you see below, but vehicles do not provide the specs that fit. We have experts that know this information, it’s our job as developers to associate the products with vehicles. So set up database tables and relationships that can help us associate the wheel products to the vehicles that fit.

**Vehicle Data**
```
	unique_vehicle_id: 12345678
	Year: 2018
	Make: Subaru
	Model: WRX
```

**Wheel_product_source1:**
```
	Id: 1
	bolt_pattern: 5x113
	Offset: 8
	Width:7
	Diameter: 19
	Finish: black
	Sku: asdfg123
	Brand: Method
```

**Wheel_product_source2:**
```
	id:1
	bolt_pattern: 5x113
	Offset: 8
	Width:8
	Diameter: 18
	Finish: black
	Sku: zxcv7890
	Brand: Rotiform
```


## Observations

I'd recommend building out a couple of structures - and exactly how this is done can vary.

First, for vehicles themselves, it seems like what we have is going to need to be a composed record, based on customer input - I have a VW GTI, Model year 2018, but crucially, I have the autobahn version of the car, which means it has larger brake rotors, and needs rims that will fit correctly over those.

Seems safe to say that at the very least the trim level, in addition to the model, needs to be captured - Subaru's website lists 18-inch alloys as standard on the premium, limited and GT trims of the WRX, but not the base.  Tirerack and company select manufacturer, year, model and trim.  Seems like we'd need to do the same - with probably three of those all possibly present on the main vehicle's table.

So Manufacturers, which have many Cars, which have_many Trims.  A trim specifies minimum and maximums for offset, width and wheel diameter, along with the bolt pattern - though I suppose that could be on the Car itself.  

Then we'd need to load manufacture data into our wheels table, which will store: 
bolt_pattern
offset
width
diameter
along with some vendor info like finish, sku, brand and vendor_id - need to retain those foreign ids, I'm assuming, so that we can order parts.

I've built these migrations, along with some semi-randomized seed data in db/seeds, and a function in models/trim to find wheels that fit for a given trim based on this structure.

Ultimately, the speed here will be down to the database and its indexes.  The bolt pattern is an equality check, and there's only one, so that would need to be indexed and then the remaining conditional columns on wheels should also be indexed (offset, width, diameter).  



