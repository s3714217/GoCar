var oldSelectId;
var newSelectId;

function main() {
    updateCar();
    updateParking1(); // increment no of cars
    updateParking2(); // decrement no of cars
}

$.getOldSelected = function () {
    oldSelectId = $('#updateLocation :selected').attr('id');
}

function parking() {
    // Provides select option from parking location collection
    db.collection("parking_location").get().then((snapshot) => {
        snapshot.docs.forEach(doc => {
            var listParkings1 = document.querySelector("#updateLocation");
            var option1 = document.createElement("option");
            var address1 = doc.data().Address;

            option1.setAttribute("id", doc.id);
            option1.setAttribute("value", address1);
            option1.textContent = address1;
            listParkings1.appendChild(option1);
        })
        select("updateLocation", sessionStorage.getItem("carLocation"));
        $.getOldSelected();
    })
}

function select(selectId, optionValToSelect) {
    // Get the select element by its unique ID
    var selectElement = document.getElementById(selectId);

    // Get the options
    var selectOptions = selectElement.options;

    // Loop through the options using for loop
    for (var opt, j = 0; opt = selectOptions[j]; j++) {
        // if option of value is equal to the option we want to select
        if (opt.value == optionValToSelect) {
            // select option and break out the for loop
            selectElement.selectedIndex = j;
            break;
        }
    }
}

function sendCarDetails() {
    var rego = document.getElementById("rego");
	var type = document.getElementById("type");
	var model = document.getElementById("model");
	var rate = document.getElementById("updateRate");
	
    rego.innerHTML = sessionStorage.getItem("carID");
    rego.setAttribute("value", sessionStorage.getItem("carID"));

    type.innerHTML = sessionStorage.getItem("carType");
    type.setAttribute("value", sessionStorage.getItem("carType"));

    model.innerHTML = sessionStorage.getItem("carModel");
    model.setAttribute("value", sessionStorage.getItem("carModel"));

    select("updateCondition", sessionStorage.getItem("con"));
    select("updateStatus", sessionStorage.getItem("carStatus"));

    rate.innerHTML = sessionStorage.getItem("carRate");
    rate.setAttribute("value", sessionStorage.getItem("carRate"));
}

function updateCar() {
    var carLocation = document.getElementById("updateLocation").value;
    var carCondition = document.getElementById("updateCondition").value;
    var carStatus = document.getElementById("updateStatus").value;
    var carRate = document.getElementById("updateRate").value;
    var rateNum = parseInt(carRate);
	var isTrue = false;
	
    // Validates for editing existing car
    if (rateNum < 100 || rateNum > 500) {
        document.getElementById('rateNumError').innerHTML = "Please enter a rate between 100 and 500";
        return;
    }

    if (carStatus === "Available") {
        isTrue = false;
    } else if (carStatus === "Leased") {
        isTrue = true;
    }

    if (carRate === "") {
        document.getElementById('carRateEmpty').innerHTML = "Please enter a car rate";
        return;
    }

    // Checks onto Cloud Firestore (database), validates the edited car details
    db.collection("cars").doc(sessionStorage.getItem("carID")).update({
            parking_location: carLocation,
            condition: carCondition,
            leased: isTrue,
            rate: rateNum
        })
        .then(function () {
            document.getElementById('updateSuccess').innerHTML = "Successfully updated car";
            window.location.replace("car.html");
        })
        .catch(function (error) {
            document.getElementById('updateError').innerHTML = "Error updating document";
        });
}

$.getNewSelected = function () {
    newSelectId = $('#updateLocation :selected').attr('id');
}

function updateParking1() {
    $.getNewSelected();
    var increment = firebase.firestore.FieldValue.increment(1);
    db.collection("parking_location").doc(newSelectId).update({
            Number_cars: increment
        })
        .then(function () {
			
        })
        .catch(function (error) {
            document.getElementById("updateParking1Error").innerHTML = "Error in updating document";
        });
}

function updateParking2() {
    var decrement = firebase.firestore.FieldValue.increment(-1);
    db.collection("parking_location").doc(oldSelectId).update({
            Number_cars: decrement
        })
        .then(function () {
            
        })
        .catch(function (error) {
            document.getElementById("updateParking2Error").innerHTML = "Error in updating document";
        });
}

function carCancel() {
    window.location.replace("car.html");
}