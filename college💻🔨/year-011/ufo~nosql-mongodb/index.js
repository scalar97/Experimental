const mongoose = require('mongoose');
const csv = require('csv-parse')
const fs = require('fs')

// loop through the rows here and create a sight object

mongoose.connect('mongodb://localhost/ufo')

// create a UFO object Schema
const UFOSchema = new mongoose.Schema({
    _id: {type: mongoose.Schema.Types.ObjectId, required: true, auto: true},
    shape: String, // one to few?
    summay: String,
    seen_date: {type:Date, Required: 'Seen date must be specified'},
    updated_date: Date,
    seen_duration: String
});

// one-to-squillions: one city can have a lot of ufo sightings
const CitySchema = new mongoose.Schema({
        city_name: { type: String, index: true, unique: true, required: true
    },
    ufos:[mongoose.Schema.Types.ObjectId] // rerefence to ufos
});

// one to many: one state can have many cities
const StateSchema = new mongoose.Schema({
    state_code: {type:String, required: true, index:true, auto: true,unique: true},
    cities:[mongoose.Schema.Types.ObjectId]
});

// compile the schemas into a model
const UFOState = mongoose.model('state', StateSchema);
const UFOCity = mongoose.model('city', CitySchema);
const UFO = mongoose.model('ufo', UFOSchema);

function save_sight(state_name,city_name,ufo) {
    UFOCity.findOne({city_name: city_name}, function(error, city){
	if(!city){
	    // insert a brand new city
	    var new_city = new UFOCity({city_name:city_name});
	    save_ufo(new_city, ufo, function(err, updated_city){
		if(!err)
		    save_state(state_name, updated_city); // save this city to a state
	    });
	    
	} else {
	    save_ufo(city, ufo, function(err, success){
		if(!err) console.log('added ufo')
	    });
	}
    })
}
function save_ufo(city, ufo, callback){
    ufo.save(function(err, ufo){
	if(!err){
	    city.ufos.push(ufo._id);
	    city.save(callback);
	}
    })
}

function save_state(s_code, city){
    UFOState.findOne({state_code: s_code}, function(error, state){
	if(state){
	    // update state check if this city was never added to it
	    UFOState.find({
		cities: city._id
	    }, function(err, s) {
		if(!err && s[0] == null){
		    state.cities.push(city._id);
		    state.save(function(err, updated_state){
			if(!err) console.log('added city '+ city.city_name+' to state: '+ s_code);
		    });
		}
	    });
	} else {
	    // new state first time seen
	    var new_state = UFOState({state_code:s_code});
	    new_state.cities.push(city._id)
	    new_state.save({function(err, state){
		    if(!err) console.log('saved new state');
		}	
	    });
	}
    })
}
/*
ufo = new UFO({shape: 'oval'});
save_sight('GB','Leeds', ufo);
*/
const Headers = Object.freeze({"SEEN_DATE":0, "STATE":1,"CITY":2, "SHAPE":3, "SUMMARY":4, "POSTED":5, "DURATION":6})


fs.createReadStream('ufo.csv')
  .pipe(csv())
  .on('readable', function(){
      console.log(this.read()[0]) // skip headers
      let record
      while(record = this.read()) {
	  ufo = new UFO({
	      shape: record[Headers.SHAPE],
	      seen_date: record[Headers.SEEN_DATE],
	      summay: record[Headers.SUMMARY],
	      duration: record[Headers.DURATION],
	      posted: record[Headers.POSTED]
	  })
	  save_sight(record[Headers.STATE], record[Headers.CITY], ufo);
      }
  })
  .on('end', () => {
      console.log('finished');
  })
