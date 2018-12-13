const mongoose = require('mongoose')
const csv = require('csv-parse')
const fs = require('fs')

// connect
mongoose.connect('mongodb://localhost/ufo')

// create a UFO object Schema
const UFOSchema = new mongoose.Schema({
    _id: {type: mongoose.Schema.Types.ObjectId, required: true, auto: true},
    shape: String, // one to few?
    summay: String,
    seen_date: {type:Date, Required: 'Seen date must be specified'},
    updated_date: Date,
    seen_duration: String
})
// one-to-squillions: one city can have a lot of ufo sightings
const CitySchema = new mongoose.Schema({
        city_name: { type: String, index: true, required: true
    },
    ufos:[mongoose.Schema.Types.ObjectId] // rerefence to ufos
})
// one to many: one state can have many cities
const StateSchema = new mongoose.Schema({
    state_code: {type:String, required: true, index:true, auto: true,unique: true},
    cities:[mongoose.Schema.Types.ObjectId]
})
// compile the schemas into a model
const UFOState = mongoose.model('state', StateSchema)
const UFOCity = mongoose.model('city', CitySchema)
const UFO = mongoose.model('ufo', UFOSchema)

// load data from CSV file
const Headers = Object.freeze({"SEEN_DATE":0, "STATE":1,"CITY":2, "SHAPE":3, "SUMMARY":4, "POSTED":5, "DURATION":6})
seen_state = {}
seen_city = {}
loaded_ufos = []

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
	  state_code = record[Headers.STATE]  == "" ? "NONE" : record[Headers.STATE]
	  city_name = record[Headers.CITY] == "" ? "Unkown" : record[Headers.CITY]
	  // I refuse to nest dictionaties here.
	  // e.g the state: CO, city: Denver, will be refered to as CO/Denver as opposed to state{name:CO, cities:{'Denver',...}}
	  // this will work just like a nested city in state dictionary would but with no overhead of nested dicts complexeity.
	  city_code = state_code +"/"+ city_name 

	  // insert a state if first time seen
	  if (!seen_state[state_code]){
	      seen_state[state_code]= new UFOState({state_code: state_code})
	  }
	  // insert city if first time seen
	  if (!seen_city[city_code]){
	      new_city = new UFOCity({city_name: city_name})
	      seen_state[state_code].cities.push(new_city._id)
	      seen_city[city_code] = new_city
	  }
	  // or else just add ufo to that sity in that state
	  seen_city[city_code].ufos.push(ufo._id)
	  loaded_ufos.push(ufo)
      }
  })
  .on('end', () => { // PERFORM BULK INSERT
      // insert all ufos
      UFO.insertMany(loaded_ufos, function(err, sucess){
	  if(!err) console.log("SUCCESS: inserted UFOS")
	  else console.log("FAIL: couldn't insert UFOs: err: "+ err)
      })
      // insert all cities
      UFOCity.insertMany(Object.values(seen_city), function(err, sucess){
	  if(!err) console.log("SUCCESS: inserted cities")
	  else console.log("FAIL: couldn't insert cities: err: " + err)
      })
      // insert all states
      UFOState.insertMany(Object.values(seen_state), function(err, sucess){
	  if(!err) console.log("SUCCESS: inserted states")
	  else console.log("FAIL: couldn't insert states: err: " + err)
      })
  })
