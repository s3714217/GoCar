// Sorts the search bar functions
$(document).ready(function () {
    $("#searchInput").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#carTable tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });
});

function renderCars(doc) {
	// Variable declarations
	
    // Renders all of the fields onto the table
    var listCars = document.querySelector("#carTable");
    var tr = document.createElement("tr");
    var td1 = document.createElement("td");
    var td2 = document.createElement("td");
    var td3 = document.createElement("td");
    var td4 = document.createElement("td");
    var td5 = document.createElement("td");
    var td6 = document.createElement("td");

    // Dynamically create the elements onto the table
    var carRego = document.createElement("span");
    var model = document.createElement("span");
    var parkingLocation = document.createElement("span");
    var vehicleType = document.createElement("span");
    var leased = document.createElement("span");
    var editCar = document.createElement("button");
    var removeCar = document.createElement("button");
	
	// Random IDs generated for buttons
	var autoEditId = Math.floor(Math.random() * 300);
    var autoRemoveId = Math.floor(Math.random() * 300);
	
	// Condition and rate used for editing car
    // Won't be shown on table
    var condition = document.createElement("span");
    var rate = document.createElement("span");
	
	var rId = "";
    var eId = "";

    // Provide bootstrap classes to change the layout of button
    editCar.className = "btn btn-primary";
    removeCar.className = "btn btn-secondary";
    vehicleType.className = "capital";

    condition.textContent = doc.data().condition;
    rate.textContent = doc.data().rate;

    // Dynamically add text content to the fields on table
    carRego.textContent = doc.id;
    model.textContent = doc.data().model;
    parkingLocation.textContent = doc.data().parking_location;
    vehicleType.textContent = doc.data().vehicle_type;
    leased.textContent = doc.data().leased;

    // Dynamically set attribute of id and value to the buttons
    editCar.setAttribute("id", autoEditId);
    removeCar.setAttribute("id", autoRemoveId);

    editCar.setAttribute("value", doc.id);
    removeCar.setAttribute("value", doc.id);

    editCar.textContent = "Edit";
    removeCar.textContent = "Remove";

    // Change colour of status if available or leased
    if (leased.textContent === "true") {
        leased.textContent = "Leased";
        leased.className = "text-danger";
    } else if (leased.textContent === "false") {
        leased.textContent = "Available"
        leased.className = "text-success";
    }

	// Adds the car elements onto the table
    td1.appendChild(carRego);
    td2.appendChild(model);
    td3.appendChild(parkingLocation);
    td4.appendChild(vehicleType);
    td5.appendChild(leased);
    td6.appendChild(editCar);
    td6.appendChild(removeCar);

    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3);
    tr.appendChild(td4);
    tr.appendChild(td5);
    tr.appendChild(td6);

    listCars.appendChild(tr);

    rId = document.getElementById(autoRemoveId);
    eId = document.getElementById(autoEditId);

	// Stores car data temporarily, to be retrieved in the edit_car.html page.
    editCar.addEventListener("click", function () {
        sessionStorage.setItem("carID", eId.value);
        sessionStorage.setItem("carType", vehicleType.textContent);
        sessionStorage.setItem("carModel", model.textContent);
        sessionStorage.setItem("carLocation", parkingLocation.textContent);
        sessionStorage.setItem("con", condition.textContent);
        sessionStorage.setItem("carStatus", leased.textContent);
        sessionStorage.setItem("carRate", rate.textContent);
        window.location.replace("edit_car.html");
    });

    // Validate if it can remove the selected car
    removeCar.addEventListener("click", function () {
        db.collection("cars").doc(rId.value).delete()
            .then(function () {
                document.getElementById("removeSuccess").innerHTML = "Car was successfully removed";
                document.location.reload(true);
            })
            .catch(function (error) {
                document.getElementById("removeFailure").innerHTML = "Car could not be removed";
            });
    });
}

// Loops through all the cars in the database 
function cars() {
    db.collection("cars").get().then((snapshot) => {
        snapshot.docs.forEach(doc => {
            renderCars(doc);
        })
    })
}

// Function to go back to the add_car.html page
function addCarButton() {
    window.location.replace("add_car.html");
}