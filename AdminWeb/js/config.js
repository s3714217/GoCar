// Provides cloud configuration details for Google's Firebase
var config = {
	apiKey: "AIzaSyASKJm9Imw32FCaCdQotxlHqVvFNumFsbI",
	authDomain: "gocarrmit.firebaseapp.com",
	projectId: "gocarrmit",
	storageBucket: "gocarrmit.appspot.com",
	messagingSenderId: "213045637799",
	appId: "1:213045637799:web:8ab7ba26e7fe50feb46182",
	measurementId: "G-F84CS7CZCL"
};

// Initialises Firebase, its database and storage.
firebase.initializeApp(config);
var db = firebase.firestore();
var storage = firebase.storage();