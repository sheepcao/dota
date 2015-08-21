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
//        sendResponse(2200,json_encode($response));

        // check for tag type
        if ($tag == 'playerInfo') {
            // Request type is check Login
            $name = $_POST['name'];
//            sendResponse(2200,json_encode($name));

            
            // check for user
            $user = $db->getUserInfoByName($name);
            
//            sendResponse(2200,json_encode($user));

            if ($user != false) {
                // user found
                // echo json with success = 1
                $response["success"] = 1;
                $response["id"] = $user["id"];

                $response["username"] = $user["unique_id"];
                $response["email"] = $user["email"];
                $response["age"] = $user["age"];
                $response["sex"] = $user["sex"];
                
                $response["content"] = $user["content"];

                
                
                
                $response["isReviewed"] = $user["isReviewed"];
                $response["gameID"] = $user["gameID"];
                $response["gameName"] = $user["gameName"];

                $response["JJCinfo"]["JJCscore"] = $user["JJCscore"];
                $response["JJCinfo"]["JJCtotal"] = $user["JJCtotal"];
                $response["JJCinfo"]["JJCmvp"] = $user["JJCmvp"];
                $response["JJCinfo"]["JJCPianJiang"] = $user["JJCPianJiang"];
                $response["JJCinfo"]["JJCPoDi"] = $user["JJCPoDi"];
                $response["JJCinfo"]["JJCPoJun"] = $user["JJCPoJun"];
                $response["JJCinfo"]["JJCYingHun"] = $user["JJCYingHun"];
                $response["JJCinfo"]["JJCBuWang"] = $user["JJCBuWang"];
                $response["JJCinfo"]["JJCFuHao"] = $user["JJCFuHao"];
                $response["JJCinfo"]["JJCDoubleKill"] = $user["JJCDoubleKill"];
                $response["JJCinfo"]["JJCTripleKill"] = $user["JJCTripleKill"];
                $response["JJCinfo"]["JJCWinRatio"] = $user["JJCWinRatio"];
                $response["JJCinfo"]["JJCheroFirst"] = $user["JJCheroFirst"];
                $response["JJCinfo"]["JJCheroSecond"] = $user["JJCheroSecond"];
                $response["JJCinfo"]["JJCheroThird"] = $user["JJCheroThird"];

                
                $response["TTinfo"]["TTscore"] = $user["TTscore"];
                $response["TTinfo"]["TTtotal"] = $user["TTtotal"];
                $response["TTinfo"]["TTmvp"] = $user["TTmvp"];
                $response["TTinfo"]["TTPianJiang"] = $user["TTPianJiang"];
                $response["TTinfo"]["TTPoDi"] = $user["TTPoDi"];
                $response["TTinfo"]["TTPoJun"] = $user["TTPoJun"];
                $response["TTinfo"]["TTYingHun"] = $user["TTYingHun"];
                $response["TTinfo"]["TTBuWang"] = $user["TTBuWang"];
                $response["TTinfo"]["TTFuHao"] = $user["TTFuHao"];
                $response["TTinfo"]["TTDoubleKill"] = $user["TTDoubleKill"];
                $response["TTinfo"]["TTTripleKill"] = $user["TTTripleKill"];
                $response["TTinfo"]["TTWinRatio"] = $user["TTWinRatio"];
                $response["TTinfo"]["TTheroFirst"] = $user["TTheroFirst"];
                $response["TTinfo"]["TTheroSecond"] = $user["TTheroSecond"];
                $response["TTinfo"]["TTheroThird"] = $user["TTheroThird"];
               
                
                $response["MJinfo"]["MJscore"] = $user["MJscore"];
                $response["MJinfo"]["MJtotal"] = $user["MJtotal"];
                $response["MJinfo"]["MJmvp"] = $user["MJmvp"];
                $response["MJinfo"]["MJPianJiang"] = $user["MJPianJiang"];
                $response["MJinfo"]["MJPoDi"] = $user["MJPoDi"];
                $response["MJinfo"]["MJPoJun"] = $user["MJPoJun"];
                $response["MJinfo"]["MJYingHun"] = $user["MJYingHun"];
                $response["MJinfo"]["MJBuWang"] = $user["MJBuWang"];
                $response["MJinfo"]["MJFuHao"] = $user["MJFuHao"];
                $response["MJinfo"]["MJDoubleKill"] = $user["MJDoubleKill"];
                $response["MJinfo"]["MJTripleKill"] = $user["MJTripleKill"];
                $response["MJinfo"]["MJWinRatio"] = $user["MJWinRatio"];
                $response["MJinfo"]["MJheroFirst"] = $user["MJheroFirst"];
                $response["MJinfo"]["MJheroSecond"] = $user["MJheroSecond"];
                $response["MJinfo"]["MJheroThird"] = $user["MJheroThird"];
                
                
                sendResponse(200,json_encode($response));
            } else {
                // user not found
                // echo json with error = 1
                $response["$name"] = $name;
                $response["error"] = 1;
                $response["error_msg"] = "user not found!";
                sendResponse(417,json_encode($response));
            }
       
        }
        
        
    
    } else {
        echo "Access Denied";
    }


?>
