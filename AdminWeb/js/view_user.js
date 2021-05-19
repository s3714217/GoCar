function bookingHistory() {
    db.collection("users/" + sessionStorage.getItem("docID") + "/history").get().then((snapshot) => {
        snapshot.docs.forEach(doc => {
            renderHistoryDetails(doc);
        })
    })
}

function renderHistoryDetails(doc) {
    var li1 = document.createElement("li");
    var li2 = document.createElement("li");
    var li3 = document.createElement("li");
    var li4 = document.createElement("li");
    var li5 = document.createElement("li");
    var li6 = document.createElement("li");
    var br = document.createElement("br");
	
    var carRef = document.createElement("span");
    var carModel = document.createElement("span");
    var startDate = document.createElement("span");
    var returnDate = document.createElement("span");
    var returnAddress = document.createElement("span");
    var totalCost = document.createElement("span");
	
	var dateStart = doc.data().start_date;
    var dateStartFormat = dateStart.toDate();
    var startString = dateStartFormat.toString();
    var dateStartSub = startString.substring(0, 25);
	
	var dateReturn = doc.data().return_date;
    var dateReturnFormat = dateReturn.toDate();
    var returnString = dateReturnFormat.toString();
    var dateReturnSub = returnString.substring(0, 25);
	
    carRef.textContent = "Car Registration No: " + doc.data().carID;
    carModel.textContent = "Car Model: " + doc.data().carModel;
    startDate.textContent = "Pickup: " + dateStartSub;
    returnDate.textContent = "Return: " + dateReturnSub;
    returnAddress.textContent = "Return Address: " + doc.data().return_address;
    totalCost.textContent = "Total Cost: $" + doc.data().amount;

    li1.appendChild(carRef);
    li2.appendChild(carModel);
    li3.appendChild(startDate);
    li4.appendChild(returnDate);
    li5.appendChild(returnAddress);
    li6.appendChild(totalCost);

    historyList.appendChild(li1);
    historyList.appendChild(li2);
    historyList.appendChild(li3);
    historyList.appendChild(li4);
    historyList.appendChild(li5);
    historyList.appendChild(li6);
    historyList.appendChild(br);
}

function sendUserDetails() {
    var name = document.getElementById("name");
	var phone = document.getElementById("phone");
	var userEmail = document.getElementById("email");
	var verify = document.getElementById("verify");
	var storageRef = storage.ref();
    var verifyRef = storageRef.child("verification");
    var userRef = verifyRef.child(sessionStorage.getItem("docID"));
    var imagesRef = userRef.child("licence");
	var image = document.getElementById("licence");
	
    name.innerHTML = sessionStorage.getItem("fullName");
    name.setAttribute("value", sessionStorage.getItem("docID"));
    phone.innerHTML = sessionStorage.getItem("phoneNumber");    
    userEmail.innerHTML = sessionStorage.getItem("contactEmail");
    verify.innerHTML = sessionStorage.getItem("verified");
    verify.className = "font-weight-bold text-success";

    // Setting private URL for driver's license picture
    imagesRef.getDownloadURL()
        .then((url) => {
            image.setAttribute("src", url);
        })
        .catch((error) => {
            switch (error.code) {
                case 'storage/object-not-found':
                    // File doesn't exist
                    break;
                case 'storage/unauthorized':
                    // User doesn't have permission to access the object
                    document.getElementById("imageUnauthorized").innerHTML = "Unauthorized to view image";
                    break;
                case 'storage/canceled':
                    // User canceled the upload
                    document.getElementById("imageCancelled").innerHTML =
                        "Upload of image cancelled by user";
                    break;
                case 'storage/unknown':
                    // Unknown error occurred, inspect the server response
                    document.getElementById("unknownError").innerHTML = "Unknown error occured";
                    break;
            }
        });
}

function checkVerify() {
    var verify = document.getElementById("verify");
    var historyList = document.getElementById("historyList");
    if (verify.textContent === "Unverified") {
        verify.className = "font-weight-bold text-danger";
        historyList.style.display = "none";
    } else if (verify.textContent === "Pending") {
        verify.className = "font-weight-bold text-warning";
        historyList.style.display = "none";
    }
}

function booking() {
	var history = document.getElementById("historyList");
    db.collection("users").doc(sessionStorage.getItem("docID")).get()
        .then(doc => {
            if (doc.exists) {
                db.collection("users").doc(sessionStorage.getItem("docID")).collection("history").get()
                    .then(sub => {
                        if (sub.docs.length > 0) {
                            bookingHistory();
                        } else {
                            history.style.display = "none";
                        }
                    });
            }
        });
}

function displayDetails() {
    booking();
}

function userBack() {
    if (sessionStorage.getItem("username") === "admin_master@gocar.com") {
        window.location.replace("user_central_master.html");
    } else {
        window.location.replace("user_central.html");
    }
}