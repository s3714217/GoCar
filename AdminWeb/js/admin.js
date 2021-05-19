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
    var listAdmins = document.querySelector("#adminTable");
    var tr = document.createElement("tr");
    var td1 = document.createElement("td");
    var username = document.createElement("span");

    username.textContent = doc.id;
	
    td1.appendChild(username);
    tr.appendChild(td1);
	
    listAdmins.appendChild(tr);
}

function admins() {
    db.collection("admins").get().then((snapshot) => {
        snapshot.docs.forEach(doc => {
            renderAdmins(doc);
        })
    })
}

function changePasswordButton() {
    window.location.replace("change_password.html");
}