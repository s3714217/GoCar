<?php
session_start();

if(isset($_SESSION['portal_logged_in']) && $_SESSION['portal_logged_in'] == TRUE)
{
    switch (parse_url($_SERVER['REQUEST_URI'])['path']) {
        case '/':
            require 'main.php';
            break;
        case '/register':
            require 'register.php';
            break;
        case '/main':
            require 'main.php';
            break;
        case '/logout':
            require 'logout.php';
            break;
        default:
            http_response_code(404);
            exit('Not Found');
    }
} else {
    switch (parse_url($_SERVER['REQUEST_URI'])['path']) {
        case '/':
            require 'login.php';
            break;
        default:
            require 'login.php';
            exit;
    }
}
?>
