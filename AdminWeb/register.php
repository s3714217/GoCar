<?php
    require __DIR__ . '/vendor/autoload.php';
    use Google\Cloud\Firestore\FirestoreClient;
    session_start();

    $admin_role = $admin_first_name = $admin_last_name = $admin_username = $admin_email_address = $admin_password = '';
    $admin_role_err = $admin_first_name_err = $admin_last_name_err = $admin_username_err = $admin_email_address_err = $admin_password_err = $admin_confirm_password_err = '';
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>Register | GoCar</title>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!--CSS from Bootstrap v4.5.2-->
    <link rel="stylesheet" type="text/css" href="style/bootstrap.css">

    <!--Self defined CSS-->
    <link rel="stylesheet" type="text/css" href="style/style.css">

    <!--Javascript from Bootstrap-->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.6.0/dist/umd/popper.min.js"
        integrity="sha384-KsvD1yqQ1/1+IA7gi3P0tyJcT3vR+NdBTt13hSJ2lnve8agRGXTTyNaBYmCR/Nwi" crossorigin="anonymous">
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.min.js"
        integrity="sha384-nsg8ua9HAw1y0W1btsyWgBklPnCUAFLuTMS2G72MMONqmOymq585AcH49TLBQObG" crossorigin="anonymous">
    </script>

<!-- The core Firebase JS SDK is always required and must be listed first -->
<script src="https://www.gstatic.com/firebasejs/8.3.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/8.3.0/firebase-firestore.js"></script>
</head>

<body>
<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = [
        'name' => 'Los Angeles',
        'state' => 'CA'
    ];
    $test = $db->collection('test')->add($data);
    printf('Test: ' . PHP_EOL, $test->id());
}
?>

    <div class="container-fluid">
        <div class="row">
            <div class="col-3">
                <?php include 'header.php'; ?>
            </div>

            <div class="col-9">
                <!-- Register form -->
                <div class="container-fluid my-3 footer-align-bottom">
                    <h1 class="text-center">Register New Admin</h1>

                    <form class="mt-5" action="<?php echo basename(htmlspecialchars($_SERVER['PHP_SELF']), '.php'); ?>" method="post">
                        <div class="row mt-4">
                            <div class="form-group col-md-6">
                                <label for="adminFirstName">First Name</label>

                                <input type="text" class="form-control <?php echo !empty($staff_first_name_err) ? 'border border-danger' : ''; ?>" id="adminFirstName" name="adminFirstName" value="<?php echo $_POST['adminFirstName']; ?>">

                            </div>

                            <div class="form-group col-md-6">
                                <label for="adminLastName">Last Name</label>

                                <input type="text" class="form-control <?php echo !empty($staff_last_name_err) ? 'border border-danger' : ''; ?>" id="adminLastName" name="adminLastName" value="<?php echo $_POST['adminLastName']; ?>">

                            </div>
                        </div>

                        <div class="row mt-2">
                            <div class="form-group col-md-6">
                                <label for="adminUsername">Username</label>

                                <input type="text" class="form-control <?php echo !empty($admin_username_err) ? 'border border-danger' : ''; ?>" id="adminUsername" name="adminUsername" value="<?php echo $_POST['adminUsername']; ?>">

                                <?php
                                if (isset($admin_username_err) && !empty($admin_username_err)) {
                                    echo '<p class="text-danger mb-0">' . $admin_username_err . '</p>';

                                }
                                ?>
                            </div>


                            <div class="form-group col-md-6">
                                <label for="adminEmailAddress">Email Address</label>

                                <input type="email" class="form-control <?php echo !empty($staff_email_address_err) ? 'border border-danger' : ''; ?>" id="adminEmailAddress" name="adminEmailAddress" value="<?php echo $_POST['adminEmailAddress']; ?>" onKeyUp="changeEventButton(this)">

                                <?php
                                if (isset($admin_email_address_err) && !empty($admin_email_address_err)) {
                                    echo '<p class="text-danger mb-0">' . $admin_email_address_err . '</p>';

                                }
                                ?>
                            </div>
                        </div>

                        <div class="row mt-2">
                            <div class="form-group col-md-6">
                                <label for="adminPassword">Password</label>

                                <input type="password" class="form-control <?php echo !empty($staff_password_err) ? 'border border-danger' : ''; ?>" id="adminPassword" name="adminPassword" aria-describedby="passwordInfo" value="<?php echo $_POST['adminPassword']; ?>" onKeyUp="changeEventButton(this)">

                                <?php
                                if (isset($staff_password_err) && !empty($staff_password_err)) {
                                    echo '<p class="text-danger mb-0">' . $staff_password_err . '</p>';

                                } else {
                                    echo '<small id="passwordInfo" class="form-text text-muted">Minimum 8 characters, must contain at least 1 uppercase letter, 1 lowercase letter, 1 number digit, and 1 special character.</small>';

                                }
                                ?>
                            </div>

                            <div class="form-group col-md-6">
                                <label for="adminConfirmPassword">Confirm Password</label>

                                <input type="password" class="form-control <?php echo !empty($admin_confirm_password_err) ? 'border border-danger' : ''; ?>" id="adminConfirmPassword" name="adminConfirmPassword" value="<?php echo $_POST['adminConfirmPassword']; ?>">

                                <?php
                                if (isset($admin_confirm_password_err) && !empty($admin_confirm_password_err)) {
                                    echo '<p class="text-danger mb-0">' . $admin_confirm_password_err . '</p>';

                                }
                                ?>
                            </div>
                        </div>

                        <button id="registerSubmitButton" type="submit" class="btn btn-primary btn-block mt-5">
                            <span id="submitButton">Register</span>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
  // Your web app's Firebase configuration
  // For Firebase JS SDK v7.20.0 and later, measurementId is optional
  var firebaseConfig = {
    apiKey: "AIzaSyASKJm9Imw32FCaCdQotxlHqVvFNumFsbI",
    authDomain: "gocarrmit.firebaseapp.com",
    projectId: "gocarrmit",
    storageBucket: "gocarrmit.appspot.com",
    messagingSenderId: "213045637799",
    appId: "1:213045637799:web:8ab7ba26e7fe50feb46182",
    measurementId: "G-F84CS7CZCL"
  };
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);
</script>
    

    <?php include 'footer.php'; ?>
</body>
</html>