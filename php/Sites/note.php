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
    function sendResponse($status = 200, $body = '', $content_type = 'application/json')
    {
        $status_header = 'HTTP/1.1 ' . $status . ' ' . getStatusCodeMessage($status);
        header($status_header);
        header('Content-type: ' . $content_type);

        echo $body;
    }

//    sendResponse(2200,json_encode($_POST));
//
//    sendResponse(2300,json_encode($_FILES));
    
    if (isset($_POST['tag']) && $_POST['tag'] != '') {
        // get tag
        $tag = $_POST['tag'];
        
//        sendResponse(2200,json_encode($tag));

        // include db handler
        require_once 'include/DB_Functions.php';
        $db = new DB_Functions();

        // response Array
        $response = array("tag" => $tag, "success" => 0, "error" => 0);
//        sendResponse(2200,json_encode($_POST));

        // check for tag type
        if ($tag == 'addNote') {
            // Request type is check Login
            $content = $_POST['content'];
            $username = $_POST['username'];
            $visitor = $_POST['visitor'];

//            sendResponse(2200,json_encode($_POST));

            
            // check for user
            $userSignature = $db->storeNote($content,$username,$visitor);
            
//            $response["error_msg"] = $userSignature;
//
//            sendResponse(200,json_encode($response));

            if ($userSignature != false) {
                // user found
                // echo json with success = 1
                $response["success"] = 1;
                
                
                while($row = mysql_fetch_array($userSignature))
                {
                    $response["id"][] = $row["id"];
                    $response["username"][] = $row["username"];
                    $response["content"][] = $row["note_content"];
                    $response["visitor"][] = $row["visitor"];
                    $response["createdAt"][] = $row["createdAt"];
                    
                }

                sendResponse(200,json_encode($response));
            } else {
                // user not found
                // echo json with error = 1
                $response["success"] = 0;
                $response["error"] = 1;
                $response["error_msg"] = $userSignature;
                sendResponse(417,json_encode($response));
            }
        }else if($tag == 'getNote') {
            // Request type is check Login
            $username = $_POST['username'];
        
            // check for user
            $userSignature = $db->fetchNotes($username);
            
            if ($userSignature != false) {
                // user found
                // echo json with success = 1
                $response["success"] = 1;

                while($row = mysql_fetch_array($userSignature))
                {
                    $response["id"][] = $row["id"];
                    $response["username"][] = $row["username"];
                    $response["content"][] = $row["note_content"];
                    $response["visitor"][] = $row["visitor"];
                    $response["createdAt"][] = $row["createdAt"];
                    
                }
                sendResponse(200,json_encode($response));
            } else {
                // user not found
                // echo json with error = 1
                $response["success"] = 0;
                $response["error"] = 1;
                $response["error_msg"] = "no records";
                sendResponse(417,json_encode($response));
            }
        }else {
            echo "Invalid Request";
        }
        
        
        
    } else {
        echo "Access Denied";
    }

    
    

?>
