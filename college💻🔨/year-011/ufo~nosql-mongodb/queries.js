// Tatiana ZIhindula
// C16339923
// Year 3: NoSQL Assignment with MongoDB
// Dataset: UFO sightings
// 14/12/2018


// QUERIES: see schema in ./index.js


//1. get all state names and the number of their cities sorted in ascending order of redistred city count
db.states.aggregate([
   {
      $project: {
         _id: 0,
         state_code:1,
         number_of_cities:{ $size: "$cities" }
      }
   },
   {$sort : { 'number_of_cities' : -1}}
])


//2.  get the name of cities outside of the US and their UFO counts
db.cities.aggregate([
     {
       $project:
         {
           _id:"$_id",
           _id: 0,
           ufo_count: { $size: "$ufos" },
           "city name": "$city_name",
           "not from the US" : {
        		$in: [ "$_id", db.states.findOne({state_code: 'NONE'}).cities ]
      		}
         }
     },
     { $match: { "not from the US" : true }},
     { $sort : { "city name" : 1} }
])

//3. get the ufos sightings in Ireland
irish_ufos = db.cities.find( { city_name: { $regex: /ireland/i }}).toArray()

//4. create an index on the ufos so that they could be queried directly
db.cities.createIndex({"ufos": 1});


//5. test the index with secific object ID
c = db.cities.findOne( {ufos: ObjectId("5c12c47e52cf683b1d7d788f") } )

//6. get the ufo data including the irish city name of this specific ufo
db.ufos.aggregate(
    [
    	{ $match : { _id : {$in: c.ufos }}},
    	{ $project:
    	  { shape:1,
    	    seen_date:1,
    	    city: c.city_name,
    	    seen_duration:1
    	  },
    	},
    ]
);


//7. return the city that has had at least 5 ufos sightings
db.cities.aggregate([
   {
      $project: {
         _id: 0,
         city_name:1,
         ufo_count: { $cond: { if: { $gte: [ { $size: "$ufos" }, 5 ] }, then: { $size: "$ufos" }, else: "we don't see UFOs here much"} }
      }
   }
])


//8. return UFO That were seen in New York in 2015
NY = db.cities.findOne({city_name: 'New York'})
db.ufos.aggregate([
     {
       $project:
         {
           _id:"$_id",
           _id: 0,
           seen_date: "$seen_date",
           year: { $year: "$seen_date"},
           shape:1,
           "seen in New York" : { $in: [ "$_id", NY.ufos ]}
         }
     },
     { $match: { $and: [ { "seen in New York" : true },  { "year" : 2015 } ] } },
])

/*
//9. return the state with the most UFO sights ever

/*
// 9.0
// what I wanted to do : for every doc in states(top level collection) count the number of ufo sights(lowest level collect) and return total as one number

// ATTEMPT 1: use stand alone aggregation and use a dynamic subquery in $reduce based on current cities._id from in $states.cities
// DID IT WORK?: NO.
// WHAT WENT WRONG?: mongodb 'db' cannot be referenced inside aggregations/nor in a mapreduce functions for a multitude of reasons?
// https://jira.mongodb.org/browse/SERVER-4525
// https://stackoverflow.com/a/21026975

// with non-straighford work around?

b = db.cities.aggregate([
	{
	  $project: {
	    ufo_count: { $size: "$ufos" }
	  }
	},
	{ $sort : { 'ufo_count' : -1 } }
])

db.states.aggregate(
  [
    {
      $project: {
        "state_code": 1,
        "results": {
          $reduce: {
            input: "$cities",
            initialValue: 0,
            in: { $add: [ "$$value", {db.cities.findOne({ '_id': '$$this'}).ufos.length} ] } // '$$this' DID NOT WORK
          }
        }
      }
    }
  ]
)
*/

// ATTEMPT 2: using map reduce with $lookup to join the results 
// 			  accumulated in the cities collection to the states collection.
// DID IT WORK?: YES.
// WHAT WENT RIGHT?: [..seat back or grab some popcorn..]
// first of all, I reduced every row in the cities collection to the lenght  
// of its cities.ufos subcollection, using map reduce below
var mapCityUfos = function() {
	emit(this._id, this.ufos.length);
};
var reduceCities = function(city_id, values) {
         return values;
};
db.cities.mapReduce(
    mapCityUfos,
    reduceCities,
    { out:"at_last"} // the map reduce output will be saved in a collection called 'at_last'
)
db.at_last.find() // view the reduced result..

// Then I fed 'at_last' above to the state collection and filtered the output to end up with the state with the most sights count ever

db.states.aggregate(
[
  	{
      $unwind: "$cities"    // flatten the city _ids
    },
    {
      $lookup:				// join the map reduced city_id to ufocount above
         {
            from: "at_last",
            localField: "cities",
            foreignField: "_id",
            as: "ufo_count"
        }
   },
   {
      $unwind: "$ufo_count" // flatten city object array
   },
   { $project: // only interested in the state in question and its ufo count, thank you very much!
     {
       state_code:1,
       count: "$ufo_count.value"
     }
   },
    {
        $group : // group by state ID and by state code
        {
           '_id' : {
             '_id': '$_id',
             'state_code':'$state_code'
           },
           total_sights: { $sum: '$count'} // get the sum of all sights per city, per state
        }
     },
     { // sort in the total number of signts in descending order of sights, alphabetical order of state code e.g CA comes before CO
       // change -1 to 1 to view the city with the least sights
     	$sort : { 'total_sights' : -1, 'state_code': 1}
     },
     {  // uncomment to leave the city with the most sights
	// or change this value to view N of them
     	$limit : 1
     }
  ]
)

// FINAL THOUGHTS ON USING MAP-REDUCE AFTER BEING CLOSE TO GIVING UP

// after successfully mapping and reducing the ciities collection then embedding the output in the state collection.
// I started wondering if creating a view like in typical relational DBMS.. couldn've have made this whole thing easier?

// the collections I designed were fully normalised with 1 to many(state-city) and one to squillion relationships(city-ufo).
// this saves on updates/delete as the state name is not replicated many time and so is the city name
// but in my opinion made queries more complex and possibly affected the armotized time complexeity?
// which I won't calculate, but what I mean is the cost of $lookup, $unwind, $$this $etc
// I doubt will be cheaper than transversing this same dataset if it was denormaised.
// this dataset is not typical for updates/deletes so that normalisation could have been overlooked given the nature of the data.

// data is now structured (which NoSQL is not supposed to be about?) and I don't see much gain in memory being used if references still have to be kept.
// maybe the 16MB limitation of doc size would be hit if every UFO sighting now added a gallery field to hold the pictures when the event happened.
// and then I 'the programmer' would wish I had the UFO object thier own collections etc..
// but with just a 'summary' description barely using 1Kib, I don't see any need of storing tights references of 1 to many or one to squillions
// as asked in this assignment brief. as least considering the nature of this data.

// as take away, the $lookup aggregation ('flag' it's called?), turned out to be very useful and mostly all I could've needed..
// it offers the possibility of embed output from subqueries inside the current aggregation.
// as a result,
// I could've then just $unwind states.cities, then join the whole cities collection using $lookup.
// reduce it to the length of its ufos subcollection array then group the output by state, by ufo count.

// This could have made the above below a bit longer, possibly complex, but I guess thats's when
// MAP-REDUCE with its {out: 'at_last'} dynamic collection came in handy, as it devided the job neded to be done.