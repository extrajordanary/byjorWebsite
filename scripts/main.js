var wordInterval, randomNumber, groupWord, thingWord, actionWord, adjectiveWord;
// var myHeading = document.querySelector('h1');
document.querySelector('h1').innerHTML = 'EXTRAJORDANARY';

wordInterval = setInterval(function(){ changeWords() }, 2000);

function changeWords() {
	randomNumber = [Math.floor(Math.random() * words['groups'].length)];
	groupWord = words['groups'][randomNumber];

	randomNumber = [Math.floor(Math.random() * words['things'].length)];
	thingWord = words['things'][randomNumber];

	randomNumber = [Math.floor(Math.random() * words['actions'].length)];
	actionWord = words['actions'][randomNumber];

	randomNumber = [Math.floor(Math.random() * words['adjectives'].length)];
	adjectiveWord = words['adjectives'][randomNumber];

	document.querySelector('.group-word').innerHTML = groupWord;
	document.querySelector('.thing-word').innerHTML = thingWord;
	document.querySelector('.thing-word2').innerHTML = thingWord;
	document.querySelector('.action-word').innerHTML = actionWord;
	document.querySelector('.adjective-word').innerHTML = adjectiveWord;
}
