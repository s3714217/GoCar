<?php 
    require __DIR__ . '/vendor/autoload.php';
    session_start();
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>Dashboard | GoCar</title>

    <meta charset="utf-8">
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
</head>

<body>
    <!--Main Dashboard-->
    <div class="container-fluid">
        <div class="row">
            <div class="col-3">
                <?php include 'header.php'; ?>    
            </div>

            <div class="col-9">
                <div class="container-fluid my-3 footer-align-bottom">
                    <h1 class="text-left font-weight-bold ml-15">Dashboard</h1>
                    <p class="ml-15"><?php echo date('jS F Y'); ?></p>

                    <div class="row mt-5">
                        <div class="col-3 border shadow bg-white rounded-lg p-3">
                            <div class="d-flex">
                                <h5 class="my-auto text-black-50 font-weight-bold">Total Users</h5>

                                <span class="ml-auto">
                                    <img src="style/total_users.svg" alt="Total Users Icon">
                                </span>
                            </div>

                            <p class="h2 font-weight-bold">200</p>
                        </div>

                        <div class="col px-0"></div>

                        <div class="col-3 border shadow bg-white rounded-lg p-3">
                            <div class="d-flex">
                                <h5 class="my-auto text-black-50 font-weight-bold">Total Cars Available</h5>

                                <span class="ml-auto">
                                    <img src="style/total_cars_available.svg" alt="Total Cars Icon">
                                </span>
                            </div>

                            <p class="h2 font-weight-bold text-success">200</p>
                        </div>

                        <div class="col"></div>

                        <div class="col-3 border shadow bg-white rounded-lg p-3">
                            <div class="d-flex">
                                <h5 class="my-auto text-black-50 font-weight-bold">Parking Available</h5>

                                <span class="ml-auto">
                                    <img src="style/parking_available.svg" alt="Parking Available Icon">
                                </span>
                            </div>

                            <p class="h2 font-weight-bold">40</p>
                        </div>
                    </div>

                    <!--Notifications row-->
                    <div class="row mt-5">
                        <div class="col border shadow bg-white rounded-lg p-3">
                            <h5 class="my-auto text-black-50 font-weight-bold">Notifications</h5>

                            <p class="h2 font-weight-bold">40</p>
                        </div>
                    </div>

                    <!--Notifications row-->
                    <div class="row mt-5">
                        <div class="col-9 border shadow bg-white rounded-lg p-3">
                            <div class="d-flex">
                                <h5 class="my-auto text-black-50 font-weight-bold">Recent Bookings</h5>

                                <span class="ml-auto">
                                    <a href="#">
                                        More
                                    
                                        <img src="style/arrow_right_alt-24px 1.svg" alt="Right Arrow Icon">
                                    </a>
                                </span>
                            </div>

                            <p class="h2 font-weight-bold">40</p>
                        </div>

                        <div class="col-1 px-0"></div>

                        <div class="col-2 border shadow bg-white rounded-lg p-3">
                            <h5 class="my-auto text-black-50 font-weight-bold">Recent Activity</h5>
                        </div>
                    </div>
                </div>

                <?php include 'footer.php'; ?>
            </div>
        </div>
    </div>
</body>

</html>
