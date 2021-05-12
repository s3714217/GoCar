// Sorts the search bar functions
$(document).ready(function () {
    $("#searchInput").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $("#userTable tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });
});

function renderUsers(doc) {
    var listUsers = document.querySelector("#userTable");

    var tr = document.createElement("tr");
    var td1 = document.createElement("td");
    var td2 = document.createElement("td");
    var td3 = document.createElement("td");
    var td4 = document.createElement("td");

    var userID = document.createElement("span");
    var fullName = document.createElement("span");
    var verified = document.createElement("span");
    var phoneNumber = document.createElement("span");
    var contactEmail = document.createElement("span");

    var verifyUser = document.createElement("button");
    var viewUser = document.createElement("button");

    verifyUser.className = "btn btn-primary";
    viewUser.className = "btn btn-primary";

    fullName.textContent = doc.data().fullName;
    verified.textContent = doc.data().verified;
    phoneNumber.textContent = doc.data().phoneNumber;
    contactEmail.textContent = doc.data().contactEmail;

    var uID = doc.id;
    var userIDString = uID.toString();
    var userIDSub = userIDString.substring(0, 4);
    userID.textContent = userIDSub + "...";

    var autoVerifyID = Math.floor(Math.random() * 300);
    var autoViewID = Math.floor(Math.random() * 300);

    verifyUser.setAttribute("id", autoVerifyID);
    viewUser.setAttribute("id", autoViewID);

    verifyUser.setAttribute("value", doc.id);
    viewUser.setAttribute("value", doc.id);

    verifyUser.textContent = "Verify";
    viewUser.textContent = "View";

    // Hide verify button if user is verified
    // Change colour of verification status if unverified/pending
    if (verified.textContent === "verified") {
        verifyUser.disabled = true;
        verifyUser.className = "btn invisible";
        verified.textContent = "Verified";
        verified.className = "text-success";
    } else if (verified.textContent === "unverified") {
        verified.textContent = "Unverified";
        verified.className = "text-danger";
    } else if (verified.textContent === "pending") {
        verified.textContent = "Pending"
        verified.className = "text-warning";
    }

    td1.appendChild(userID);
    td2.appendChild(fullName);
    td3.appendChild(verified);
    td4.appendChild(verifyUser);
    td4.appendChild(viewUser);

    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3);
    tr.appendChild(td4);

    listUsers.appendChild(tr);

    var docID = doc.id;
    var vwID = document.getElementById(autoViewID);
    var vrID = document.getElementById(autoVerifyID);

    // Sets all of the required field inputs for the View User page
    viewUser.addEventListener("click", function () {
        localStorage.setItem("fullName", fullName.textContent);
        localStorage.setItem("phoneNumber", phoneNumber.textContent);
        localStorage.setItem("verified", verified.textContent);
        localStorage.setItem("contactEmail", contactEmail.textContent);
        localStorage.setItem("docID", docID);
        window.location.replace("view_user.html");
    });

    // Validates if it can verify the selected user
    verifyUser.addEventListener("click", function () {
        localStorage.setItem("name", fullName.textContent);
        localStorage.setItem("email", contactEmail.textContent);
        db.collection("users").doc(vrID.value).update({
                verified: "verified",
            })
            .then(function () {
                document.getElementById('verifySuccess').innerHTML =
                    "User was successfully verified";
                sendEmail();
            })
            .catch(function (error) {
                document.getElementById('verifyFailure').innerHTML = "User could not be verified";
            });
    });
}

function sendEmail() {
    // send email to user that account is verified
    db.collection("mail").doc().set({
            to: localStorage.getItem("email"),
            message: {
                subject: "GoCar - Account Verification",
                text: "Hi " + localStorage.getItem("name") +
                    ", this is an email confirmation that your account has been verified by GoCar."
            }
        })
        .then(function () {
            document.getElementById('emailSuccess').innerHTML = "Email was successfully sent";
            document.location.reload(true);
        })
        .catch(function (error) {
            document.getElementById('emailFailure').innerHTML = "Email could not be sent";
        });
}

function users() {
    db.collection("users").get().then((snapshot) => {
        snapshot.docs.forEach(doc => {
            renderUsers(doc);
        })
    })
}