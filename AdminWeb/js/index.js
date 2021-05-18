function signIn() {
    var txtUsername = document.getElementById("username").value;
    var txtPassword = document.getElementById("password").value;
	var emailRe = /^.+@gocar\.com$/;
	var username = "";
	var password = "";
	
    // Validation for login credentials
    if (txtUsername === "") {
        document.getElementById('usernameEmpty').innerHTML = "Please enter a username";
        return;
    }

    if (txtPassword === "") {
        document.getElementById('passwordEmpty').innerHTML = "Please enter a password";
        return;
    }

    if (txtUsername.match(emailRe)) {

    } else {
        document.getElementById('usernameInvalid').innerHTML = "Please enter a valid username";
        return;
    }

    username = txtUsername;
    sessionStorage.setItem("username", username);
    password = txtPassword;

    // Checks onto Cloud Firestore (database) and validate the login credentials
    db.collection("admins").doc(username).get()
        .then(function (doc) {
            if (doc.exists) {
                var getPassword = doc.data().password;
                if (password === getPassword) {
                    window.location.replace("dashboard.html");
                } else {
                    document.getElementById("passwordError").innerHTML = "Please enter a valid password";
                }
            } else {
                document.getElementById("usernameError").innerHTML = "Please enter an existing username";
            }
        })
        .catch(function (error) {
            document.getElementById("loginError").innerHTML = "Account unable to login";
        });
}

function resetUsername() {
    var username;
    sessionStorage.setItem("username", username);
}