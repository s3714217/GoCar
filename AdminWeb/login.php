<html>

<head> 
    <title>Login | GoCar</title>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!--Bootstrap links-->

    <!--Javascript from Bootstrap-->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.6.0/dist/umd/popper.min.js" integrity="sha384-KsvD1yqQ1/1+IA7gi3P0tyJcT3vR+NdBTt13hSJ2lnve8agRGXTTyNaBYmCR/Nwi" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.min.js" integrity="sha384-nsg8ua9HAw1y0W1btsyWgBklPnCUAFLuTMS2G72MMONqmOymq585AcH49TLBQObG" crossorigin="anonymous"></script>


</head>

<body>
    <!--Login Form-->
    <div class="container">
        <div class="row">
            <h1 class="text-center mt-3">Login</h1>
            
            <form action="" method="POST">
                <div class="form-group">
                    <!--Form validation for admin username-->
                    <label for="Username">Username</label>

                    <input type="text" class="form-control" id="Username" name="username" placeholder="Enter Username" value="">
                </div>

                <div class="form-group">
                    <!--Form validation for admin password-->
                    <label for="Password">Password</label>

                    <input type="password" class="form-control" id="Password" name="password" placeholder="Enter Password" value="">
                </div>

                <button type="submit" class="btn btn-primary login-btn-block">Login</button>
            </form>
        </div>
    </div>
</body>

</html>