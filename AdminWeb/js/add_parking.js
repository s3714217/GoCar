function parkingAdd() {
    var address = document.getElementById("parkingAddress").value;
    var latitude = document.getElementById("parkingLatitude").value;
    var longitude = document.getElementById("parkingLongitude").value;
    var latitudeNum = parseFloat(latitude);
    var longitudeNum = parseFloat(longitude);

    // Validation for adding new parking
    if (latitudeNum < -90 || latitudeNum > 90) {
        document.getElementById("latitudeNumError").innerHTML = "Please enter a latitude between -90 and 90";
        return;
    }

    if (longitudeNum < -180 || longitudeNum > 180) {
        document.getElementById("longitudeNumError").innerHTML =
            "Please enter a longitude between -180 and 180";
        return;
    }

    if (address === "") {
        document.getElementById('parkingAddressEmpty').innerHTML = "Please enter an address";
        return;
    }

    if (latitude === "") {
        document.getElementById('parkingLatitudeEmpty').innerHTML = "Please enter a latitude";
        return;
    }

    if (longitude === "") {
        document.getElementById('parkingLongitudeEmpty').innerHTML = "Please enter a longitude";
        return;
    }

    var geo = new firebase.firestore.GeoPoint(latitudeNum, longitudeNum);

    // Checks onto Cloud Firestore (database), validate if parking details exist
    db.collection("parking_location").doc().set({
            Address: address,
            Location: geo,
            Number_cars: 0,
        })
        .then(function () {
            document.getElementById("addSuccess").innerHTML =
                "Parking location was added successfully";
            window.location.replace("parking.html");
        })
        .catch(function (error) {
            document.getElementById("addFailure").innerHTML = "Parking location could not be added";
        });
}

function main() {
    parkingAdd();
}

function parkingCancel() {
    window.location.replace("parking.html");
}