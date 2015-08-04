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
    
    if (isset($_POST['tag']) && $_POST['tag'] != '') {
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
            $gameName = $_POST['gameName'];
//            sendResponse(200,json_encode($gameName));

            $JJCinfo["haveScore"] = $_POST['JJChaveScore'];
            $TTinfo["haveScore"] = $_POST['TThaveScore'];
            $MJinfo["haveScore"] = $_POST['MJhaveScore'];

            if ($_POST['JJChaveScore'] == "yes")
            {
                
                $JJCinfo["JJCscore"] = $_POST['JJCscore'];
                $JJCinfo["JJCtotal"] = $_POST['JJCtotal'];
                $JJCinfo["JJCmvp"] = $_POST['JJCmvp'];
                $JJCinfo["JJCPianJiang"] = $_POST['JJCPianJiang'];
                $JJCinfo["JJCPoDi"] = $_POST['JJCPoDi'];
                $JJCinfo["JJCPoJun"] = $_POST['JJCPoJun'];
                $JJCinfo["JJCYingHun"] = $_POST['JJCYingHun'];
                $JJCinfo["JJCBuWang"] = $_POST['JJCBuWang'];
                $JJCinfo["JJCFuHao"] = $_POST['JJCFuHao'];
                $JJCinfo["JJCDoubleKill"] = $_POST['JJCDoubleKill'];
                $JJCinfo["JJCTripleKill"] = $_POST['JJCTripleKill'];
                $JJCinfo["JJCWinRatio"] = $_POST['JJCWinRatio'];
                $JJCinfo["JJCheroFirst"] = $_POST['JJCheroFirst'];
                $JJCinfo["JJCheroSecond"] = $_POST['JJCheroSecond'];
                $JJCinfo["JJCheroThird"] = $_POST['JJCheroThird'];
            }
            
            if ($_POST['TThaveScore'] == "yes")
            {
                $TTinfo["TTscore"] = $_POST['TTscore'];
                $TTinfo["TTtotal"] = $_POST['TTtotal'];
                $TTinfo["TTmvp"] = $_POST['TTmvp'];
                $TTinfo["TTPianJiang"] = $_POST['TTPianJiang'];
                $TTinfo["TTPoDi"] = $_POST['TTPoDi'];
                $TTinfo["TTPoJun"] = $_POST['TTPoJun'];
                $TTinfo["TTYingHun"] = $_POST['TTYingHun'];
                $TTinfo["TTBuWang"] = $_POST['TTBuWang'];
                $TTinfo["TTFuHao"] = $_POST['TTFuHao'];
                $TTinfo["TTDoubleKill"] = $_POST['TTDoubleKill'];
                $TTinfo["TTTripleKill"] = $_POST['TTTripleKill'];
                $TTinfo["TTWinRatio"] = $_POST['TTWinRatio'];
                $TTinfo["TTheroFirst"] = $_POST['TTheroFirst'];
                $TTinfo["TTheroSecond"] = $_POST['TTheroSecond'];
                $TTinfo["TTheroThird"] = $_POST['TTheroThird'];
            }
            
            if ($_POST['MJhaveScore'] == "yes")
            {
                $MJinfo["MJscore"] = $_POST['MJscore'];
                $MJinfo["MJtotal"] = $_POST['MJtotal'];
                $MJinfo["MJmvp"] = $_POST['MJmvp'];
                $MJinfo["MJPianJiang"] = $_POST['MJPianJiang'];
                $MJinfo["MJPoDi"] = $_POST['MJPoDi'];
                $MJinfo["MJPoJun"] = $_POST['MJPoJun'];
                $MJinfo["MJYingHun"] = $_POST['MJYingHun'];
                $MJinfo["MJBuWang"] = $_POST['MJBuWang'];
                $MJinfo["MJFuHao"] = $_POST['MJFuHao'];
                $MJinfo["MJDoubleKill"] = $_POST['MJDoubleKill'];
                $MJinfo["MJTripleKill"] = $_POST['MJTripleKill'];
                $MJinfo["MJWinRatio"] = $_POST['MJWinRatio'];
                $MJinfo["MJheroFirst"] = $_POST['MJheroFirst'];
                $MJinfo["MJheroSecond"] = $_POST['MJheroSecond'];
                $MJinfo["MJheroThird"] = $_POST['MJheroThird'];
            }
            
//            sendResponse(200,json_encode($_POST));
        
        
            $user = $db->updateUserLevel($username,$isReviewed,$gameID,$gameName,$JJCinfo,$TTinfo,$MJinfo);
            

            
            if ($user != false) {
                $response["success"] = 1;
                
                $response["username"] = $user["unique_id"];
                $response["isReviewed"] = $user["isReviewed"];
                $response["gameID"] = $user["gameID"];
//                $response["user"] = $user;

                if(isset($user["JJCscore"]) && $user["JJCscore"] != '')
                {
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
                    $response["JJCinfo"]["JJCcreated_Time"] = $user["JJCcreated_Time"];
                }
//
                if($user["TTscore"])
                {
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
                    $response["TTinfo"]["TTcreated_Time"] = $user["TTcreated_Time"];
                    
                }
                if($user["MJscore"])
                {
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
                    $response["MJinfo"]["MJcreated_Time"] = $user["MJcreated_Time"];
                }
                sendResponse(200,json_encode($response));

            } else {
        

                $response["error"] = 1;
                $response["error_msg"] = "confirm failed";
                sendResponse(4030,json_encode($response));
            }

        }
        
    
//
    } else {
        echo "Access Denied";
    }
//
//    
?>
