function user() {
    var user = document.getElementById("user");
    user.innerHTML = sessionStorage.getItem("adminName");
}

function change() {
    var newPass = document.getElementById("newPassword").value;
    var confirmPass = document.getElementById("confirmPassword").value;

    // Validation for changing password details for master admin
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

    // Checks onto Cloud Firestore (database) and validate the master admin credentials
    db.collection("admins").doc(sessionStorage.getItem("adminName")).update({
            password: newPass
        })
        .then(function () {
            document.getElementById("updatePasswordSuccess").innerHTML =
                "Password was successfully updated";
            window.location.replace("admin_master.html");
        })
        .catch(function (error) {
            document.getElementById("updatePasswordError").innerHTML = "Password could not updated";
        })
}

function adminCancel() {
    window.location.replace("admin_master.html");
}