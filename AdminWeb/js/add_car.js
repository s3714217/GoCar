// Global variable declarations
var selectId;

// Main function for Add button, invoked on-click
function main() {
    carAdd();
    updateParking();
}

function parking() {
    // Provides select option from parking location collection
    db.collection("parking_location").get().then((snapshot) => {
        snapshot.docs.forEach(doc => {
            var listParkings1 = document.querySelector("#parkingLocation");
            var option1 = document.createElement("option");
            var address1 = document.createElement("span");

            option1.setAttribute("id", doc.id);
            address1.textContent = doc.data().Address;
            option1.setAttribute("value", doc.data().Address);

            option1.appendChild(address1);

            listParkings1.appendChild(option1);
        })
    })
}

function carAdd() {
	// Variable declarations
    var txtModel = document.getElementById("carModel").value;
    var optCondtion = document.getElementById("carCondition").value;
    var optLocation = document.getElementById("parkingLocation").value;
    var optType = document.getElementById("carType").value;
    var txtRate = document.getElementById("carRate").value;
    var txtCarID = document.getElementById("carID").value;
	var carLeased = false;
    var rateNum = parseInt(txtRate);
	var carIdRe = /^\d{7}$/;
	
    // Validation for adding new car
    if (rateNum < 100 || rateNum > 500) {
        document.getElementById('rateNumError').innerHTML = "Please enter a rate between 100 and 500";
        return;
    }

    // Regular expression for validating Car ID
    if (txtCarID.match(carIdRe)){
		
    } else {
        document.getElementById('carIDError').innerHTML =
            "Please enter a car registration between 0000000 and 9999999";
        return;
    }
	
	// Checks if text boxes are empty
    if (txtCarID === "") {
        document.getElementById('carIDEmpty').innerHTML = "Please enter a car registration number";
        return;
    }

    if (txtModel === "") {
        document.getElementById('carModelEmpty').innerHTML = "Please enter a car model";
        return;
    }

    if (txtRate === "") {
        document.getElementById('carRateEmpty').innerHTML = "Please enter a car rate";
        return;
    }

    // Checks onto Cloud Firestore (database), validate if car details exist
    db.collection("cars").doc(txtCarID).get()
        .then(function (doc) {
            if (doc.exists) {
                document.getElementById('carIDExist').innerHTML = "Car registration number already exists";
            } else {
                db.collection("cars").doc(txtCarID).set({
                    condition: optCondtion,
                    leased: carLeased,
                    model: txtModel,
                    parking_location: optLocation,
                    rate: rateNum,
                    vehicle_type: optType
                })
                document.getElementById('carAddedSuccess').innerHTML = "Car was added successfully";
            }
        })
        .catch(function (error) {
            document.getElementById('carAddedFailure').innerHTML = "Car could not be added";
        });
}

// Stores the currently selected parking location
$.getSelected = function () {
    selectId = $('#parkingLocation :selected').attr('id');
}

// Updates the Number_cars field by 1 in the parking_location collection, for the currently selected parking location
function updateParking() {
    $.getSelected();
    var increment = firebase.firestore.FieldValue.increment(1);
    db.collection("parking_location").doc(selectId).update({
            Number_cars: increment
        })
        .then(function () {
			
        })
        .catch(function (error) {
            document.getElementById("updateParkingError").innerHTML = "Could not update parking";
        });
}

// Function to go back to car.html page
function carCancel() {
    window.location.replace("car.html");
}