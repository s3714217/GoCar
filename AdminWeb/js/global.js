// Store global variables and functions

var username;

function getValues(){
	if (localStorage.getItem("storageName") == null){
		alert("Please enter a username and password");
		window.location.replace("index.html");
	} else {
		var userDiv = document.getElementById("user");
		var countUserDIV = document.getElementById("countUsers");
		var countCarDiv = document.getElementById("countCars");
		var countParkingsDiv = document.getElementById("countParkings");
		userDiv.innerHTML = "Welcome " + localStorage.getItem("storageName");
		db.collection("users").get().then(snap => {
			var size = snap.size; // will return the collection size
			countUserDIV.innerHTML = size;
		});
		db.collection("cars").get().then(snap => {
			var size = snap.size; // will return the collection size
			countCarDiv.innerHTML = size;
		});
		db.collection("parking_location").get().then(snap => {
			var size = snap.size; // will return the collection size
			countParkingsDiv.innerHTML = size;
		})
	}

}

function adminPage() {
	if (localStorage.getItem("storageName") == "admin_master@gocar.com") {
		window.location.replace("admin_master.html");
	} else {
		window.location.replace("admin.html");
	}
}

function userPage() {
	if (localStorage.getItem("storageName") === "admin_master@gocar.com") {
		window.location.replace("user_central_master.html");
	} else {
		window.location.replace("user_central.html");
	}
}

function logOut() {
	username = null;
	localStorage.setItem("storageName", username);
	window.location.replace("index.html");
}
