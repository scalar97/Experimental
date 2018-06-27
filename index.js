'use strict';

// import dependencies and set up http server
const

express = require('express'),
bodyParser = require('body-parser'),
app = express().use(bodyParser.json()); // create express http server
var port = (process.env.PORT == null) ? 1337 : process.env.PORT;
// listen to the PORT env variable or else 1337 : WASTE port maybe
app.listen(port, () => console.log('webhook is listening to port '+port+'\n'));

// create the /webhook endpoint
app.post('/webhook', (req, res) => {
    let body = req.body;
    // check this is an event from a page subscription
    if (body.object === 'page') {
	// itterate over each entry - there may be multple if batched
	body.entry.forEach(function(entry) {
	    // gets the message. entry.messaging is an array but will 
	    // only ever contain one message, so we get entry at index0
	    let webhook_event = entry.messaging[0];
	    console.log(webhook_event);
	});
	// returns a '200 OK' response to all requests
	res.status(200).send('EVENT_RECEIVED');
    } else {
	// return a '404 not found' if event is not from a page subscription
	res.sendStatus(404);
    }
});

// add GET request support to webhook

app.get('/webhook', (request, response) =>{
    // verify token. should be a random string
    let VERIFY_TOKEN = "MY_VERIFY_TOKEN_STRING";

    // parse the query params
    let mode = request.query['hub.mode'];
    let token = request.query['hub.verify_token'];
    let challenge = request.query['hub.challenge'];

    // checks if the token and mode is in the query string of the request
    if (mode && token) {
	// check if the mode and the token sent are correct
	if (mode ==='subscribe' && token === VERIFY_TOKEN) {
	    console.log('WEBHOOK_VERIFIED');
	    response.status(200).send(challenge);
	} else {
	    // respond with '403 Forbidden' if verify tokens do not match
	    response.sendStatus(403);
	}
    }
});
