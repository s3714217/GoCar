function adminAdd() {
    var txtUsernameSU = document.getElementById("adminUsername").value;
    var txtPasswordSU = document.getElementById("adminPassword").value;

    // Validation for adding new admin
    if (txtUsernameSU === "") {
        document.getElementById('adminUsernameEmpty').innerHTML = "Please enter a username";
        return
    }

    if (txtPasswordSU === "") {
        document.getElementById('adminPasswordEmpty').innerHTML = "Please enter a password";
        return
    }

    if (txtPasswordSU.length < 8) {
        document.getElementById("passwordLengthError").innerHTML = "Password must be minimum 8 characters long";
        return
    }

    var usernameRE = /^.+@gocar\.com$/;
    if (txtUsernameSU.match(usernameRE)) {

    } else {
        document.getElementById("adminUsernameInvalid").innerHTML = "Please enter a valid email address";
        return
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

function adminCancel() {
    window.location.replace("admin_master.html");
}