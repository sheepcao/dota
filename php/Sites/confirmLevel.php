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
//        header('Accept' = 'image/jpeg');

        echo $body;
    }

//
//    sendResponse(2300,json_encode($_FILES));
    
    if (isset($_POST['tag']) && $_POST['tag'] != '') {
        // get tag
        $tag = $_POST['tag'];


        // include db handler
        require_once 'include/DB_Functions.php';
        $db = new DB_Functions();
        // response Array
        $response = array("tag" => $tag, "success" => 0, "error" => 0);

        if ($tag == 'confirmLevel') {
            $isReviewed = "yes";
            
            $username = $_POST['username'];
            $gameID = $_POST['gameID'];
            $JJCscore = $_POST['JJCscore'];
            $TTscore = $_POST['TTscore'];
            $ratio = $_POST['ratio'];
            $soldier = $_POST['soldier'];
            $heroFirst = $_POST['heroFirst'];
            $heroSecond = $_POST['heroSecond'];
            $heroThird = $_POST['heroThird'];
            
            
            $user = $db->updateUserLevel($username,$isReviewed,$gameID,$JJCscore,$TTscore,$ratio,$soldier,$heroFirst,$heroSecond,$heroThird);
            
            
            
            if ($user != false) {
                $response["success"] = 1;

             


           
                
                $response["username"] = $user["username"];
                $response["isReviewed"] = $user["isReviewed"];
                $response["JJCscore"] = $user["JJCscore"];
                $response["gameID"] = $user["gameID"];
                $response["TTscore"] = $user["TTscore"];
                $response["WinRatio"] = $user["WinRatio"];
                $response["soldier"] = $user["soldier"];
                $response["heroFirst"] = $user["heroFirst"];
                $response["heroSecond"] = $user["heroSecond"];
                $response["heroThird"] = $user["heroThird"];
                $response["created_Time"] = $user["created_Time"];
                
                sendResponse(200,json_encode($response));

            } else {
        

                $response["error"] = 1;
                $response["error_msg"] = "confirm failed";
                sendResponse(4030,json_encode($response));
            }
        }
        
    } else {
        echo "Access Denied";
    }

    
?>
