<?php

/**
 * File to handle all API requests
 * Accepts GET and POST
 *
 * Each request will be identified by TAG
 * Response will be JSON data

 /**
 * check for POST request
 */
    
    function getStatusCodeMessage($status)
    {
        // these could be stored in a .ini file and loaded
        // via parse_ini_file()... however, this will suffice
        // for an example
        $codes = Array(
                       100 => 'Continue',
                       101 => 'Switching Protocols',
                       200 => 'OK',
                       201 => 'Created',
                       202 => 'Accepted',
                       203 => 'Non-Authoritative Information',
                       204 => 'No Content',
                       205 => 'Reset Content',
                       206 => 'Partial Content',
                       300 => 'Multiple Choices',
                       301 => 'Moved Permanently',
                       302 => 'Found',
                       303 => 'See Other',
                       304 => 'Not Modified',
                       305 => 'Use Proxy',
                       306 => '(Unused)',
                       307 => 'Temporary Redirect',
                       400 => 'Bad Request',
                       401 => 'Unauthorized',
                       402 => 'Payment Required',
                       403 => 'Forbidden',
                       404 => 'Not Found',
                       405 => 'Method Not Allowed',
                       406 => 'Not Acceptable',
                       407 => 'Proxy Authentication Required',
                       408 => 'Request Timeout',
                       409 => 'Conflict',
                       410 => 'Gone',
                       411 => 'Length Required',
                       412 => 'Precondition Failed',
                       413 => 'Request Entity Too Large',
                       414 => 'Request-URI Too Long',
                       415 => 'Unsupported Media Type',
                       416 => 'Requested Range Not Satisfiable',
                       417 => 'Expectation Failed',
                       500 => 'Internal Server Error66',
                       501 => 'Not Implemented',
                       502 => 'Bad Gateway',
                       503 => 'Service Unavailable',
                       504 => 'Gateway Timeout',
                       505 => 'HTTP Version Not Supported'
                       );
        
        return (isset($codes[$status])) ? $codes[$status] : '';
    }
    
    // Helper method to send a HTTP response code/message
    function sendResponse($status = 200, $body = '', $content_type = 'text/html')
    {
        $status_header = 'HTTP/1.1 ' . $status . ' ' . getStatusCodeMessage($status);
        header($status_header);
        header('Content-type: ' . $content_type);
        echo $body;
    }

    
    
if (isset($_POST['tag']) && $_POST['tag'] != '') {
	// get tag
	$tag = $_POST['tag'];
    

	// include db handler
	require_once 'include/DB_Functions.php';
	$db = new DB_Functions();

	// response Array
	$response = array("tag" => $tag, "success" => 0, "error" => 0);

	// check for tag type
	if ($tag == 'login') {
		// Request type is check Login
		$email = $_POST['email'];
		$password = $_POST['password'];

		// check for user
		$user = $db->getUserByEmailAndPassword($email, $password);
		if ($user != false) {
			// user found
			// echo json with success = 1
			$response["success"] = 1;
			$response["uid"] = $user["unique_id"];
			$response["user"]["name"] = $user["name"];
			$response["user"]["email"] = $user["email"];
			$response["user"]["created_at"] = $user["created_at"];
			$response["user"]["updated_at"] = $user["updated_at"];
			sendResponse(200,json_encode($response));
		} else {
			// user not found
			// echo json with error = 1
			$response["error"] = 1;
			$response["error_msg"] = "Incorrect email or password!";
            sendResponse(403,json_encode($response));
		}
	} else if ($tag == 'register') {
		// Request type is Register new user
		$name = $_POST['name'];
		$email = $_POST['email'];
		$password = $_POST['password'];
        $age = $_POST['age'];
        $sex = $_POST['sex'];
        
        
		// check if user is already existed
		if ($db->isUserExisted($name)) {
			// user is already existed - error response
            $responseError =array("error_msg" => "User already existed");
//			$response["error"] = 2;
//			$response["error_msg"] = "User already existed";
            sendResponse(4042,json_encode($responseError));
		} else {
			// store user
			$user = $db->storeUser($name, $email, $password, $age, $sex);
			if ($user) {
				// user stored successfully
				$response["success"] = 1;
				$response["username"] = $user["unique_id"];
				$response["email"] = $user["email"];
                $response["age"] = $user["age"];
                $response["sex"] = $user["sex"];
				$response["created_at"] = $user["created_at"];
				$response["updated_at"] = $user["updated_at"];
                sendResponse(200,json_encode($response));
			} else {
				// user failed to store
				$response["error"] = 1;
				$response["error_msg"] = "Error occurred in Registration";
                sendResponse(4,json_encode($response));
			}
		}
	} else {
		echo "Invalid Request";
	}
} else {
	echo "Access Denied";
}
?>
