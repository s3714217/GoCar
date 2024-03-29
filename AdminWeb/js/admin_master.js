// Sorts the search bar functions
$(document).ready(function () {
    $("#searchInput").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#adminTable tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });
});

// Renders the list of admins onto the table
function renderAdmins(doc) {
	// Variable declarations
    var listAdmins = document.querySelector("#adminTable");
    var tr = document.createElement("tr");
    var td1 = document.createElement("td");
    var td2 = document.createElement("td");
	
    var username = document.createElement("span");
    var changePassword = document.createElement("button");
    var removeAdmin = document.createElement("button");
	
	var autoEditId = Math.floor(Math.random() * 900);
    var autoRemoveId = Math.floor(Math.random() * 900);
	
	// Adds the admins onto the table
    username.textContent = doc.id;

    changePassword.setAttribute("id", autoEditId);
    changePassword.setAttribute("value", doc.id);
    changePassword.textContent = "Edit";
    changePassword.className = "btn btn-primary";

    removeAdmin.setAttribute("id", autoRemoveId);
    removeAdmin.setAttribute("value", doc.id);
    removeAdmin.textContent = "Remove";
    removeAdmin.className = "btn btn-secondary";
	
	if (username.textContent === "admin_master@gocar.com"){
		removeAdmin.style.display = "none";
	}

    td1.appendChild(username);
    td2.appendChild(changePassword);
    td2.appendChild(removeAdmin);

    tr.appendChild(td1);
    tr.appendChild(td2);

    listAdmins.appendChild(tr);

    var rId = document.getElementById(autoRemoveId);

	// Redirects to the change_password_master.html page.
    changePassword.addEventListener("click", function () {
        sessionStorage.setItem("adminName", doc.id);
        window.location.replace("change_password_master.html")
    });

    // Validates if it can remove the admin account
    removeAdmin.addEventListener("click", function () {
            db.collection("admins").doc(rId.value).delete()
                .then(function () {
                    document.getElementById("removeAdminSuccess").innerHTML =
                        "Admin was successfully removed";
                    document.location.reload(true);
            })
            .catch(function (error) {
                document.getElementById("removeAdminFailure").innerHTML =
                    "Admin could not be removed";
            });
    });
}

// Loops through all the admins in the database 
function admins() {
    db.collection("admins").get().then((snapshot) => {
        snapshot.docs.forEach(doc => {
            renderAdmins(doc);
        })
    })
}

// Function to go back to add_admin.html page
function addAdminButton() {
    window.location.replace("add_admin.html");
}