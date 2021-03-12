<?php 
// require_once __DIR__ . '/vendor/autoload.php';

/**
 * Checks that the JWT assertion is valid (properly signed, for the
 * correct audience) and if so, returns strings for the requesting user's
 * email and a persistent user ID. If not valid, returns null for each field.
 *
 * @ param string $assertion The JWT string to assert.
 * @ param string $audience The audience of the JWT.
 *
 * @ return string[] array containing [$email, $id]
 * @ throws Exception on failed validation
 */
/* function validate_assertion(string $idToken, string $audience) : array 
{
    $auth = new Google\Auth\AccessToken();
    $info = $auth->verify($idToken, [
        'certsLocation' => Google\Auth\AccessToken::IAP_CERT_URL,
      'throwException' => true,
    ]);

    if ($audience != $info['aud'] ?? '') {
        throw new Exception(sprintf(
            'Audience %s did not match expected %s', $info['aud'], $audience
        ));
    }

    return [$info['email'], $info['sub']];

}

switch (@parse_url($_SERVER['REQUEST_URI'])['path']) {
    case '/':
        if (!Google\Auth\Credentials\GCECredentials::onGce()) {
            throw new Exception('You must deploy to appengine to run this sample');
        }
        $metadata = new Google\Cloud\Core\Compute\Metadata();
        $audience = sprintf(
            '/projects/%s/apps/%s',
            $metadata->getNumericProjectId(),
            $metadata->getProjectId()
        );
        $idToken = getallheaders()['X-Goog-Iap-Jwt-Assertion'] ?? '';
        try {
            list($email, $id) = validate_assertion($idToken, $audience);
            printf("<h1>Hello %s</h1>", $email);
        } catch (Exception $e) {
            printf('Failed to validate assertion: %s', $e->getMessage());
        }
        break;
    case '': break; // Nothing to do, we're running our tests
    default:
        http_response_code(404);
        exit('Not Found');
}
*/

?>

<!DOCTYPE html>
<html>

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
    <div id="landing-page">
        <div id="about">
            <div class="container">
                <div class="row">
                    <div class="col">
                        <h2>Dashboard</h2>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <?php include 'header.php'; ?>

    <?php include 'footer.php'; ?>
</body>

</html>
