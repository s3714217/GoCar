// Store global variables and functions

var username;

function getValues(){
		if (localStorage.getItem("storageName") == null){
			alert("Please enter a username and password");
			window.location.replace("index.html");
		} else {
			var userDiv = document.getElementById("user");
			var countUserDiv = document.getElementById("countUsers");
			var countParkingsDiv = document.getElementById("countParkings");
			var countCarDiv = document.getElementById("countCars");
			userDiv.innerHTML = "Welcome " + localStorage.getItem("storageName");
			db.collection("cars").get().then(snap => {
				var size = snap.size; // will return the collection size
				countCarDiv.innerHTML = "No of Cars " + size;
			});
			db.collection("users").get().then(snap => {
				var size = snap.size; // will return the collection size
				countUserDiv.innerHTML = "No of Users " + size;
			});
			db.collection("parking_location").get().then(snap => {
				var size = snap.size; // will return the collection size
				countParkingsDiv.innerHTML = "No of Parking Locations " + size;
			});
		}
}

function logOut(){
		username = null;
		window.location.replace("index.html");
}	
