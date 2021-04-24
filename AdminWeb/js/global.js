// Store global variables and functions

// Checks if admin is logged in
function checkLogin(){
	if (localStorage.getItem("username") === null || localStorage.getItem("username") === "undefined"){
		document.getElementById("userNullLogin").innerHTML = "Please enter a username and password";
		window.location.replace("index.html");
	}
}

// Checks if master admin is logged in
function checkLoginMaster(){
	if (localStorage.getItem("username") != "admin_master@gocar.com"){
		document.getElementById("userAccessDenied").innerHTML = "Access is denied";
		window.location.replace("index.html");
	}
}

// Redirect to dashboard page
function dashboardPage() {
	window.location.replace("dashboard.html");
}

// Redirect to car page
function carPage() {
	window.location.replace("car.html");
}

// Redirect to parking page
function parkingPage() {
	window.location.replace("parking.html");
}

// Redirect to respective admin page according to admin role
function adminPage() {
	if (localStorage.getItem("username") == "admin_master@gocar.com") {
		window.location.replace("admin_master.html");
	} else {
		window.location.replace("admin.html");
	}
}

// Redirect to respective user page according to admin role
function userPage() {
	if (localStorage.getItem("username") === "admin_master@gocar.com") {
		window.location.replace("user_central_master.html");
	} else {
		window.location.replace("user_central.html");
	}
}

function logOut() {
	var username;
	localStorage.setItem("username", username);
	window.location.replace("index.html");
}
