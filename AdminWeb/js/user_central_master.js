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
    var userId = document.createElement("span");
    var fullName = document.createElement("span");
    var verified = document.createElement("span");
    var phoneNumber = document.createElement("span");
    var contactEmail = document.createElement("span");
    var verifyUser = document.createElement("button");
    var viewUser = document.createElement("button");
    var removeUser = document.createElement("button");

    verifyUser.className = "btn btn-primary";
    viewUser.className = "btn btn-primary";
    removeUser.className = "btn btn-secondary";

    fullName.textContent = doc.data().fullName;
    verified.textContent = doc.data().verified;
    phoneNumber.textContent = doc.data().phoneNumber;
    contactEmail.textContent = doc.data().contactEmail;

    var uId = doc.id;
    var userIdString = uId.toString();
    var userIdSub = userIdString.substring(0, 4);
    userId.textContent = userIdSub + "...";

    var autoVerifyId = Math.floor(Math.random() * 300);
    var autoViewId = Math.floor(Math.random() * 300);
    var autoRemoveId = Math.floor(Math.random() * 300);

    verifyUser.setAttribute("id", autoVerifyId);
    viewUser.setAttribute("id", autoViewId);
    removeUser.setAttribute("id", autoRemoveId);

    verifyUser.setAttribute("value", doc.id);
    viewUser.setAttribute("value", doc.id);
    removeUser.setAttribute("value", doc.id);

    verifyUser.textContent = "Verify";
    viewUser.textContent = "View";
    removeUser.textContent = "Remove";

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
        verified.textContent = "Pending";
        verified.className = "text-warning";
    }

    td1.appendChild(userId)
    td2.appendChild(fullName);
    td3.appendChild(verified);
    td4.appendChild(verifyUser);
    td4.appendChild(viewUser);
    td4.appendChild(removeUser);

    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3);
    tr.appendChild(td4);

    listUsers.appendChild(tr);

    var docId = doc.id;
    var vwId = document.getElementById(autoViewId);
    var vrId = document.getElementById(autoVerifyId);
    var rId = document.getElementById(autoRemoveId);

    viewUser.addEventListener("click", function () {
        sessionStorage.setItem("fullName", fullName.textContent);
        sessionStorage.setItem("phoneNumber", phoneNumber.textContent);
        sessionStorage.setItem("verified", verified.textContent);
        sessionStorage.setItem("contactEmail", contactEmail.textContent);
        sessionStorage.setItem("docID", docId);
        window.location.replace("view_user.html");
    });

    // Validates if it can remove the selected user
    removeUser.addEventListener("click", function () {
        db.collection("users").doc(rId.value).get()
            .then(doc => {
                if (doc.exists) {
                    db.collection("users").doc(rId.value).collection("card").get()
                        .then(sub => {
                            if (sub.docs.length > 0) {
                                // card sub-collection has documents
                                db.collection("users").doc(rId.value + "/card/payment")
                                    .delete()
                                    .then(function () {

                                    })
                            }
                            db.collection("users").doc(rId.value).collection("history")
                                .get()
                                .then(sub => {
                                    if (sub.docs.length > 0) {
                                        // history sub-collection has documents
                                        db.collection("users/" + rId.value +
                                            "/history").get().then((snapshot) => {
                                            snapshot.docs.forEach(doc => {
                                                db.collection("users")
                                                    .doc(rId.value +
                                                        "/history/" + doc.id
                                                    ).delete()
                                                    .then(function () {

                                                    })
                                            })
                                        })
                                    }
                                    // no documents in sub-collections
                                    db.collection("users").doc(rId.value).delete()
                                        .then(function () {
                                            document.getElementById("removeSuccess")
                                                .innerHTML =
                                                "User was successfully removed";
                                            document.location.reload(true);
                                        })
                                        .catch(function (error) {
                                            document.getElementById("removeFailure")
                                                .innerHTML =
                                                "User could not be removed";
                                        });
                                })
                        })
                }
            })
    });

    // Validates if it can verify the selected user
    verifyUser.addEventListener("click", function () {
        sessionStorage.setItem("name", fullName.textContent);
        sessionStorage.setItem("email", contactEmail.textContent);
        db.collection("users").doc(vrId.value).update({
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
            to: sessionStorage.getItem("email"),
            message: {
                subject: "GoCar - Account Verification",
                text: "Hi " + sessionStorage.getItem("name") +
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