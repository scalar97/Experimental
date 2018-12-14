// get all state names and the number of their cities
db.states.aggregate([
{
      $project: {
         _id: 0,
         state_code:1,
         number_of_cities: { $cond: { if: { $isArray: "$cities" }, then: { $size: "$cities" }, else: "no cities"} }
      }
   }
])

// get the name of cities outside of the US and their UFO counts
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

// get the ufos seen in Ireland
irish_ufos = db.cities.find( { city_name: { $regex: /ireland/i }})


db.ufos.findOne({_id: {$in:irish_ufos.ufos}})

// create an index on the ufos so that they could be queried directly
db.cities.findOne( { ufos: ObjectId("5c12c47e52cf683b1d7d788f") } )

// test the index with secific object ID
c = db.cities.findOne( {ufos: ObjectId("5c12c47e52cf683b1d7d788f") } )

// get the ufo data including the city name of this specific ufo
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

// return the city that has more than 5 UFO signtinds
db.cities.aggregate([
   {
      $project: {
         _id: 0,
         city_name:1,
         ufo_count: { $cond: { if: { $gte: [ { $size: "$ufos" }, 5 ] }, then: { $size: "$ufos" }, else: "we don't see UFOs here much"} }
      }
   }
])

// return UFO That were seen in New York in 2015
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
// return the state with the most UFO sights ever
// for every state count the number of signts and return total

// ATTEMPT 0: using aggregation, for some reasons mongodb is not allowing to pass a dynamic cityID through '$$this' :(
// DOES NOT WORK?
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
            in: { $add: [ "$$value", {db.cities.findOne({ '_id': '$$this'}).ufos.length} ] } // $$this DID NOT WORK, why?
          }
        }
      }
    }
  ]
)
*/
// ATTEMPT 1: using map reduce

var mapStateCity = function() {
   emit(this._id, this.cities); // map every state to its cities
};
// for every state return the total number of signts in each city
var reduceStateCity = function(state_id, state_cities) {
  var total_ufo_count = 0;
  state_cities.forEach(function(city_id) {
    total_ufo_count += city_id.ufos.length; // pull those UFOs out
  });
   return total_ufo_count; 
};
// finalizes?
var finalizeUfoCount = function (key, reducedVal) {
	return reducedVal;
};
// now retrieve the ufos
db.states.mapReduce(
    mapStateCity,
    reduceStateCity,
    { out:{merge: "at_last"},
      finalize: finalizeUfoCount
    }
)
