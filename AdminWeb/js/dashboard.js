// Sorts the search bar functions
$(document).ready(function () {
    $("#searchInput").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#recentBookingsTable tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });
});

// Return values for the summary of stats panel
function getValues() {
    var userDiv = document.getElementById("user");
    var countUserDIV = document.getElementById("countUsers");
    var countCarDiv = document.getElementById("countCars");
    var countParkingsDiv = document.getElementById("countParkings");
    userDiv.innerHTML = "Welcome " + sessionStorage.getItem("username");
    db.collection("users").get().then(snap => {
        var size = snap.size; // will return the collection size
        countUserDIV.innerHTML = size;
    });
    db.collection("cars").get().then(snap => {
        var size = snap.size; // will return the collection size
        countCarDiv.innerHTML = size;
    });
    db.collection("parking_location").get().then(snap => {
        var size = snap.size; // will return the collection size
        countParkingsDiv.innerHTML = size;
    });

}

function verifyList() {
    db.collection("users").get().then((snapshot) => {
        snapshot.docs.forEach(doc => {
            renderVerifyList(doc);
        })
    })
}

function renderVerifyList(doc) {
    var listNotifications = document.querySelector("#verify");

    var li = document.createElement("li");
    var verifyStatus = document.createElement("span");

    var fullName = doc.data().fullName;
    var verified = doc.data().verified;

    // Show list of users with pending status
    if (verified === "pending") {
        verifyStatus.textContent = fullName + " status is pending";
        li.classList.add("attention_icon");
        li.appendChild(verifyStatus);
        listNotifications.appendChild(li);
    }
}

function carsService() {
    db.collection("cars").get().then((snapshot) => {
        snapshot.docs.forEach(doc => {
            renderServiceList(doc);
        })
    })
}

function renderServiceList(doc) {
    var listNotifications = document.querySelector("#carsService");

    var li = document.createElement("li");
    var carService = document.createElement("button");

    var carID = doc.id;
    var condition = doc.data().condition;

    // Show list of cars that require service
    if (condition === "need_service") {
        carService.textContent = carID + " needs a service";
        li.classList.add("attention_icon");
        carService.className = "btn btn-link";

        carService.addEventListener("click", function () {
            sessionStorage.setItem("carID", carID);
            sessionStorage.setItem("carType", doc.data().vehicle_type);
            sessionStorage.setItem("carModel", doc.data().model);
            sessionStorage.setItem("carLocation", doc.data().parking_location);
            sessionStorage.setItem("con", condition);
            sessionStorage.setItem("carStatus", doc.data().leased);
            sessionStorage.setItem("carRate", doc.data().rate);
            window.location.replace("edit_car.html");
        });

        li.appendChild(carService);
        listNotifications.appendChild(li);

    }
}

function notifications() {
    verifyList();
    carsService();
}

function recent() {
    db.collection("transaction").get().then((snapshot) => {
        snapshot.docs.forEach(doc => {
            renderTransactions(doc);
        })
    })
}

function renderTransactions(doc) {
    var listTransactions = document.querySelector("#recentBookingsTable");

    var tr = document.createElement("tr");
    var td1 = document.createElement("td");
    var td2 = document.createElement("td");
    var td3 = document.createElement("td");
    var td4 = document.createElement("td");
    var userID = document.createElement("span");
    var carRego = document.createElement("span");
    var bookingDate = document.createElement("span");
    var returnDate = document.createElement("span");

    carRego.textContent = doc.data().carID;

    // Showing first four characters of user ID
    var uID = doc.data().userID;
    var userIDString = uID.toString();
    var userIDSub = userIDString.substring(0, 4);
    userID.textContent = userIDSub + "...";

    // Converting booking date format to string
    var dateStart = doc.data().start_date;
    var dateStartFormat = dateStart.toDate();
    var startString = dateStartFormat.toString();
    var dateStartSub = startString.substring(0, 16);
    bookingDate.textContent = dateStartSub;

    // Show most recent bookings from 1 month
    var dateNow = new Date();
    var dateMonth = new Date(dateStartFormat.setMonth(dateStartFormat.getMonth() + 1));

    // Converting return date format to string
    var dateReturn = doc.data().return_date;
    var dateReturnFormat = dateReturn.toDate();
    var returnString = dateReturnFormat.toString();
    var dateReturnSub = returnString.substring(0, 16);
    returnDate.textContent = dateReturnSub;

    if (dateMonth > dateNow) {
        td1.appendChild(userID);
        td2.appendChild(carRego);
        td3.appendChild(bookingDate);
        td4.appendChild(returnDate);
        tr.appendChild(td1);
        tr.appendChild(td2);
        tr.appendChild(td3);
        tr.appendChild(td4);
    }

    listTransactions.appendChild(tr);
}

// Arrow button that redirects to user central page
function moreArrow() {
    if (sessionStorage.getItem("username") === "admin_master@gocar.com") {
        window.location.replace("user_central_master.html");
    } else {
        window.location.replace("user_central.html");
    }
}