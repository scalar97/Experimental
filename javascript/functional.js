Array.prototype.reject = function (callback) {
    return this.filter(e => !callback(e))
}

// animal object constructor
animal = function (name, specie) {
    this.name = name
    this.specie = specie
    this.greet = function () {
	return 'My name is ' + this.name + ' I am a ' + this.specie
    }
    this.isA = function (specieName) {
	return this.specie === specieName.toLowerCase()
    }
    this.is = function (name) {
	return this.name.toLowerCase() == name.toLowerCase()
    }
}
// array of animal objects, tuple hack
var anPair = [
    'fluffy,cat',
    'marta,dog',
    'sulla,fish',
    'alexion,dog'
]
// create objects
var animals = anPair.map((e) => {
    let t = e.split(',')
    return new animal(t[0], t[1])
})

// MAP FILTER REDUCE
function BEGINER_MFR () {
    // filter the dogs
    var dogs = animals.filter(function (a) {
	return a.specie === 'dog'
    })
    console.log('The dogs are: ', dogs)

    console.log('all elm are animals? ', animals.every((e) => e instanceof animal))
    animals.push('intruder')
    console.log('all elm are animals? ', animals.every((e) => e instanceof animal))
    animals.splice(animals.length - 1, 1) // remove last element
    console.log('some elm are animals?', animals.some((e) => e instanceof animal))

    let names = []
    // get all the animal's names of the array element using a for loop
    animals.forEach((e) => {
	names.push(e.name)
    })
    let species = animals.map(function (e) { return e.specie })
    // using maps with arrow one liner
    console.log('names are', names, '\nspecies are', species)

    // using reject
    let nonDogs = animals.reject((e) => e instanceof animal && e.isA('Dog'))
    console.log('Non dogs are', nonDogs.map(a => a.name))

    let greets = animals.reduce((prevs, curr) => prevs + '\n' + curr.greet(), '\r')
    console.log(greets)

    // save the animals to disk
    let fmt = (anm) => {
	return '\n' + anm.name + ' ' + anm.specie + '\tsomething something\t12\t6'
    }
}

// FILE HANDLING + ADVANCED MAP FILTER REDUCE
function FILES_ADVANCED_MFR () {
    let fs = require('fs')
    // animals.forEach((e) => fs.appendFile('data.txt',fmt(e),(a)=> a ))
    // TODO: set this file to be a write and check if the file exist and not empty
    // convert created data above to json
    var data = fs.readFileSync('data.txt', 'utf-8', 'r')
	.trim().split('\n')
	.map((e) => e.split('\t'))
	.reduce((dct, c) => {
	    dct[c[0]] = dct[c[0]] || []
	    dct[c[0]].push({name: c[1], price: c[2], qty: c[3]})
	    return dct
	}, {})
    // if dictionary not passed, first two values will be the 2 elements in the array
    console.log(JSON.stringify(data, null, 4))
}

// CLOSURES
// inner functions have access to variables defined in the outer scope
// e.g

function CLOSURES () {
    let name = 'sulla'
    function sayName () {
	console.log('I am ' + name + '!!') // closure accessing global name
    }
    name = 'grOOt'
    sayName()
    // IMPORTANT: if value is changed for global variable, new value will be used

    // practical usecase in angular

    function request(){
	var id = 10
	$http.get('url/', {params : {id:id}})
	    .then(function(response){
		console.log('received id '+id+' at '+ Date.now())
	    })
    }

    let counter = function(){
	var initial = 0
	function changeBy(v){
	    initial += v
	}
	return {
	    increment: function(){changeBy(1)},
	    decrement: () => changeBy(-1),
	    value: function(){ return initial}
	}
    }()
    console.log(counter.value(), counter.increment(), counter.value())
    console.log(counter.decrement(), counter.value())
    
}

// BEGINER_MFR()
// FILES_ADVANCED_MFR ()
// CLOSURES()

function CURRYING(){
    
}
