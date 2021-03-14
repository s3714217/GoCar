<?php 

    require __DIR__ . '/vendor/autoload.php';
    session_start();

$login_email_address = $login_password = '';
$login_email_address_err = $login_password_err = $login_err = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $_SESSION['portal_logged_in'] = TRUE;
    header('location: /');
}

?>
<!DOCTYPE html>
<html lang="en">

<head> 
    <title>Login | GoCar</title>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!--CSS from Bootstrap v4.5.2-->
    <link rel="stylesheet" type="text/css" href="style/bootstrap.css">

    <!--Self defined CSS-->
    <link rel="stylesheet" type="text/css" href="style/style.css?<?php echo date('l jS \of F Y h:i:s A'); ?>">

    <!--Javascript from Bootstrap-->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.6.0/dist/umd/popper.min.js" integrity="sha384-KsvD1yqQ1/1+IA7gi3P0tyJcT3vR+NdBTt13hSJ2lnve8agRGXTTyNaBYmCR/Nwi" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.min.js" integrity="sha384-nsg8ua9HAw1y0W1btsyWgBklPnCUAFLuTMS2G72MMONqmOymq585AcH49TLBQObG" crossorigin="anonymous"></script>
</head>

<body id="portalLogin" class="d-flex m-0 p-0 vh-100">
    <div class="container m-auto text-center">
        <div id="loginCard" class="card bg-secondary mx-auto rounded-lg">
            <img src="style/login_logo.svg" id="logo" class="card-img-top w-50 mx-auto mt-4" alt="GoCar Logo">

            <div class="card-body">
                <h1 class="card-title">Login</h1>

                <form class="mt-5 mx-lg-5" action="" method="POST">
                    <div class="col-auto p-0">
                        <!--Form validation for admin email-->
                        <label class="sr-only" for="portalEmail">Email</label>

                        <div class="input-group border-0">
                            <input type="text" class="form-control form-control-lg border-0" id="portalEmail" name="portalEmail" placeholder="Email" value="">
                        </div>
                    </div>

                    <div class="col-auto mt-4 p-0">
                        <!--Form validation for admin password-->
                        <label class="sr-only" for="portalPassword">Password</label>

                        <div class="input-group border-0">
                            <input type="password" class="form-control form-control-lg border-0" id="portalPassword" name="portalPassword" placeholder="Password" value="">
                        </div>
                    </div>

                    <button id="loginSubmitButton" type="submit" class="btn btn-primary btn-block btn-lg mt-5 border-0">Login</button>
                </form>
            </div>

            <div class="text-logo my-4">
                <h6 class="mb-0">Copyright &copy; <?php echo date('Y'); ?> &#64; gocar.com</h6>
            </div>
            
        </div>
    </div>
</body>

</html>
