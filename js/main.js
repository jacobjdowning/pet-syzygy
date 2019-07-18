const EVENTS_URI = "/events.json";
const REF_SQUIRT_NA = new Date(2019, 6, 23);
const NUM_TRAINERS = 15;

function daysApart(first, second) {
    return Math.round(Math.abs(second-first)/(1000*60*60*24));
}

async function checkSquirt(events) {
	for (var i = 0; i < events.length; i++) {
		daysSinceSquirt = daysApart(REF_SQUIRT_NA, events[i]) % NUM_TRAINERS
		if(daysSinceSquirt > NUM_TRAINERS-7){
			let squirtDay = new Date(events[i].getFullYear(),
									 events[i].getMonth(),
									 events[i].getDate() + 
									 (NUM_TRAINERS - daysSinceSquirt));
			if (Date.now() - squirtDay < -(1000*60*60*24)) {
				return squirtDay
			}
		}
	}
}

async function getEvents() {
	let eventResponse = await fetch("/events.json");
	let eventJson = await eventResponse.json();
	let eventDates = [];
	for (var i = 0; i < eventJson.length; i++) {
		eventDates.push(new Date(eventJson[i].year,
								eventJson[i].month - 1,
								eventJson[i].day ));
	}
	return eventDates;
}

function addP(parent, contents, className) {
	let p = document.createElement('p');
	p.className = className;
	p.innerHTML = contents
	parent.appendChild(p);
}

function main() {
	let announcement = document.getElementById("announcement")
	getEvents().
	then(checkSquirt).
	then(output => addP(announcement, output.toDateString(), "date"));
}

window.onload = main;