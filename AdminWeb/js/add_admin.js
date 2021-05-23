function adminAdd() {
	// Variable declarations
    var txtUsernameSU = document.getElementById("adminUsername").value;
    var txtPasswordSU = document.getElementById("adminPassword").value;
	var usernameRe = /^.+@gocar\.com$/;
	var passwordRe = /^((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%]).{8,25})$/;
	
    // Validation for adding new admin
    if (txtUsernameSU === "") {
        document.getElementById('adminUsernameEmpty').innerHTML = "Please enter a username";
        return;
    }

    if (txtPasswordSU === "") {
        document.getElementById('adminPasswordEmpty').innerHTML = "Please enter a password";
        return;
    }

    if (txtPasswordSU.length < 8) {
        document.getElementById("passwordLengthError").innerHTML += " Password must be minimum 8 characters long";
        return;
    }

    if (txtUsernameSU.match(usernameRe)) {

    } else {
        document.getElementById("adminUsernameInvalid").innerHTML = "Please enter a valid email address";
        return;
    }

	if (txtPasswordSU.match(passwordRe)) {
		
	} else {
		document.getElementById("passwordLengthError").innerHTML += 
		" Password must meet the minimum complexity requirements: One digit from 0-9, one lower-case, one upper-case, one special character: @#$%, and a maximum of 25 characters.";
        return;
	}
	
    // Checks onto Cloud Firestore (database), validate if admin credentials exist
    db.collection("admins").doc(txtUsernameSU).get()
        .then(function (doc) {
            if (doc.exists) {
                document.getElementById('adminUsernameExist').innerHTML = "Admin username already exists";
            } else {
                db.collection("admins").doc(txtUsernameSU).set({
                        password: txtPasswordSU
                    })
                    .then(function () {
                        document.getElementById('adminAddedSuccess').innerHTML =
                            "Admin was added successfully";
                        window.location.replace("admin_master.html");
                    })
            }
        })
        .catch((error) => {
            document.getElementById("adminUsernameError").innerHTML = "Please enter a valid username";
        });
}

// Function to go back to admin_master.html page
function adminCancel() {
    window.location.replace("admin_master.html");
}