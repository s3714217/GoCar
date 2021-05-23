// Stores global functions

// Checks if admin is logged in
function checkLogin(){
	if (sessionStorage.getItem("username") === null || sessionStorage.getItem("username") === "undefined"){
		document.getElementById("userNullLogin").innerHTML = "Please enter a username and password";
		window.location.replace("index.html");
	}
}

// Checks if master admin is logged in
function checkLoginMaster(){
	if (sessionStorage.getItem("username") != "admin_master@gocar.com"){
		document.getElementById("userAccessDenied").innerHTML = "Access is denied";
		window.location.replace("index.html");
	}
}

// authentication with additional admin account
function authentication(){
	firebase.auth().signInWithEmailAndPassword("admin@gocar.com", "12345678")
			  .then((userCredential) => {
				// Signed in
				var user = userCredential.user;
			  })
			  .catch((error) => {
				var errorCode = error.code;
				var errorMessage = error.message;
			  });
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
	if (sessionStorage.getItem("username") === "admin_master@gocar.com") {
		window.location.replace("admin_master.html");
	} else {
		window.location.replace("admin.html");
	}
}

// Redirect to respective user page according to admin role
function userPage() {
	if (sessionStorage.getItem("username") === "admin_master@gocar.com") {
		window.location.replace("user_central_master.html");
	} else {
		window.location.replace("user_central.html");
	}
}

// Logs out the user from the additional admin account, clears the sessionStorage information and redirects to index.html
function logOut() {
	firebase.auth().signOut().then(() => {
		// Sign-out successful.
		document.getElementById("logoutSuccess").innerHTML = "Successfully logged out";
	  }).catch((error) => {
		// An error happened.
		document.getElementById("logoutFailure").innerHTML = "Unable to logout";
	  });
	  
	sessionStorage.clear();
	window.location.replace("index.html");
}