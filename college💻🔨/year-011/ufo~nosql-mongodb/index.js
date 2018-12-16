// Tatiana ZIhindula
// C16339923
// Year 3: NoSQL Assignment with MongoDB
// Dataset: UFO sightings

const mongoose = require('mongoose') // the library used to connect with mongodb
const csv = require('csv-parse')     // csv parser library
const fs = require('fs')             // allow access to low level file system features

// connect
mongoose.connect('mongodb://localhost/ufo')  // connect to the ufo databse on localhost

// create a UFO object Schema
const UFOSchema = new mongoose.Schema({
    _id: {type: mongoose.Schema.Types.ObjectId, required: true, auto: true},
    shape: String, // the shape of the ufo
    summay: String, // the summary(description) of the sighting
    seen_date: {type:Date, Required: 'Seen date must be specified'}, // when was it seen? in the future?
    posted: Date, // when was the sighting posted
    seen_duration: String // how long did the sighting last?
})
// one-to-squillions: one city can have a lot of ufo sightings
const CitySchema = new mongoose.Schema({
    city_name: { type: String, index: true, required: true}, // need to know what city it was seen in
    ufos:[mongoose.Schema.Types.ObjectId] // rerefence to ufos
})
// one to many: one state can have many cities
const StateSchema = new mongoose.Schema({
    state_code: {type:String, required: true, index:true, auto: true,unique: true}, // state code e.g NY, CA, CO etc
    cities:[mongoose.Schema.Types.ObjectId] // one state can have many cities
})
// compile the schemas into a model: this creates collection objects with fields matching the constraints in the schema
// collection names are automatically made plural at creation, so 'state' will be refered to as 'db.states.find(etc)'
const UFOState = mongoose.model('state', StateSchema) 
const UFOCity = mongoose.model('city', CitySchema)
const UFO = mongoose.model('ufo', UFOSchema)

// load data from CSV file
const Headers = Object.freeze({"SEEN_DATE":0, "STATE":1,"CITY":2, "SHAPE":3, "SUMMARY":4, "DURATION":5, "POSTED":6})

// temporay buffer to hold parsed collections so that they can be inserted at once.
// this will prevent making N IO inputs to the db.
// well, what if data doesn't fit in memory? it would be better to use a generator
// and parse let's say 10Mib at a time etc.. but the scope of this CA stated that the csv input file will
// not have more than 1000 rows.
// and in this particular one a row barely reaches 1Mib..
seen_state = {}
seen_city = {}
loaded_ufos = []

// start loading
fs.createReadStream('ufo.csv')
  .pipe(csv())
  .on('readable', function(){
      console.log(this.read()[0]) // skip headers
      let record
      while(record = this.read()) {
	  // initialise a ufo document. this will assign an _id to it,I do not need to initialise it myself
	  ufo = new UFO({
	      shape: record[Headers.SHAPE],
	      seen_date: record[Headers.SEEN_DATE],
	      summay: record[Headers.SUMMARY],
	      seen_duration: record[Headers.DURATION],
	      posted: record[Headers.POSTED]
	  })
	  state_code = record[Headers.STATE]  == "" ? "NONE" : record[Headers.STATE] // if there are no state assign to NONE (design decision)
	  city_name = record[Headers.CITY] == "" ? "Unkown" : record[Headers.CITY] // if there are no cities, same as above
	  // I am not nesting dictionaties of cities in counties here.
	  // e.g the state: CO, city: Denver, will be refered to as CO/Denver as opposed to state{name:CO, cities:{'Denver',...}}
	  // this will work just like a nested city in state dictionary would but with no overhead of nested dictionary complexeity.
	  city_code = state_code +"/"+ city_name 

	  // insert a brand new state if first time seen
	  if (!seen_state[state_code]){
	      seen_state[state_code]= new UFOState({state_code: state_code})
	  }
	  // insert a brand new city if first time seen
	  if (!seen_city[city_code]){
	      new_city = new UFOCity({city_name: city_name})
	      seen_state[state_code].cities.push(new_city._id)
	      seen_city[city_code] = new_city
	  }
	  // or else just add this ufo to that city that already exists,
	  // belonging to that state that already exist.
	  
	  // NOTE: the price I paid for this normalisation was somewhat complex queries
	  // as I now had to follow references in the parent-child relationship tables.
	  seen_city[city_code].ufos.push(ufo._id)
	  loaded_ufos.push(ufo)
      }
  })
  .on('end', () => { // PERFORM BULK INSERT
      // insert all ufos in bulk
      UFO.insertMany(loaded_ufos, function(err, sucess){
	  if(!err) console.log("SUCCESS: inserted UFOS")
	  else console.log("FAIL: couldn't insert UFOs: err: "+ err)
      })
      // insert all cities in bulk
      UFOCity.insertMany(Object.values(seen_city), function(err, sucess){
	  if(!err) console.log("SUCCESS: inserted cities")
	  else console.log("FAIL: couldn't insert cities: err: " + err)
      })
      // insert all states in bulk
      UFOState.insertMany(Object.values(seen_state), function(err, sucess){
	  if(!err) console.log("SUCCESS: inserted states")
	  else console.log("FAIL: couldn't insert states: err: " + err)
      })
  })
