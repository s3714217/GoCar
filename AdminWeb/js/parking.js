// Sorts the search bar functions
$(document).ready(function () {
    $("#searchInput").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#locationsTable tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });
});

function renderLocations(doc) {
    var listLocations = document.querySelector("#locationsTable");

    var tr = document.createElement("tr");
    var td1 = document.createElement("td");
    var td2 = document.createElement("td");
    var td3 = document.createElement("td");
    var td4 = document.createElement("td");

    var address = document.createElement("span");
    var location = document.createElement("span");
    var numCars = document.createElement("span");
    var removeLocation = document.createElement("button");

    removeLocation.className = "btn btn-secondary";

    address.textContent = doc.data().Address;
    location.textContent = doc.data().Location.latitude + " " + doc.data().Location.longitude;
    numCars.textContent = doc.data().Number_cars;

    var autoRemoveID = Math.floor(Math.random() * 300);

    removeLocation.setAttribute("id", autoRemoveID);
    removeLocation.setAttribute("value", doc.id);

    removeLocation.textContent = "Remove";

    td1.appendChild(address);
    td2.appendChild(location);
    td3.appendChild(numCars);
    td4.appendChild(removeLocation);

    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3);
    tr.appendChild(td4);

    listLocations.appendChild(tr);

    var rID = document.getElementById(autoRemoveID);

    // Validates if it can remove the parking location
    removeLocation.addEventListener("click", function () {
        db.collection("parking_location").doc(rID.value).delete()
            .then(function () {
                document.getElementById("removeSuccess").innerHTML =
                    "Parking location was successfully removed";
                document.location.reload(true);
            })
            .catch(function (error) {
                document.getElementById("removeFailure").innerHTML =
                    "Parking location could not be removed";
            });
    });
}

function locations() {
    db.collection("parking_location").get().then((snapshot) => {
        snapshot.docs.forEach(doc => {
            renderLocations(doc);
        })
    })
}

function addParkingButton() {
    window.location.replace("add_parking.html");
}