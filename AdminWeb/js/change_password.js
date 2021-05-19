function user() {
    var user = document.getElementById("user");
    user.innerHTML = sessionStorage.getItem("username");
}

function change() {
    var oldPass = document.getElementById("oldPassword").value;
    var newPass = document.getElementById("newPassword").value;
    var confirmPass = document.getElementById("confirmPassword").value;
	var getPassword = "";

    // Validation for changing password details
    if (oldPass === "") {
        document.getElementById("oldPassEmpty").innerHTML = "Please enter your old password";
		return;
    }

    if (newPass === "") {
        document.getElementById("newPassEmpty").innerHTML = "Please enter a new password";
		return;
    }

    if (confirmPass === "") {
        document.getElementById("confirmPassEmpty").innerHTML =
            "Please confirm the new password";
			return;
    }

    if (newPass.length < 8) {
        document.getElementById("newPassLengthError").innerHTML =
            "Password must be minimum of 8 characters long";
			return;
    }

    if (confirmPass.length < 8) {
        document.getElementById("confirmPasswordLengthError").innerHTML =
            "Confirm password must be a minimum of 8 characters long";
			return;
    }

    if (newPass != confirmPass) {
        document.getElementById("passwordNotMatch").innerHTML =
            "New password and confirmation password does not match";
        return;
    }

    // Checks onto Cloud Firestore (database), validate if old password entered is the same
    db.collection("admins").doc(sessionStorage.getItem("username")).get()
        .then(function (doc) {
            getPassword = doc.data().password;
            if (oldPass != getPassword) {
                document.getElementById("oldPassError").innerHTML = "Old password entered is incorrect";
                return;
            } else {
                db.collection("admins").doc(sessionStorage.getItem("username")).set({
                        password: newPass
                    })
                    .then(function () {
                        document.getElementById("updatePasswordSuccess").innerHTML =
                            "Password was successfully updated";
                        window.location.replace("admin.html");
                    })
            }
        })
        .catch(function (error) {
            document.getElementById("updatePasswordError").innerHTML = "Password could not updated";
        })
}

function adminCancel() {
    window.location.replace("admin.html");
}