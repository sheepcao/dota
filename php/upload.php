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
        
        
        // include db handler
        require_once 'include/DB_Functions.php';
        $db = new DB_Functions();
        
        // response Array
        $response = array("tag" => $tag, "success" => 0, "error" => 0);
        
        // check for tag type
        if ($tag == 'login') {
            // Request type is check Login
            $name = $_POST['name'];
            $password = $_POST['password'];
            
            // check for user
            $user = $db->getUserByNameAndPassword($name, $password);
            if ($user != false) {
                // user found
                // echo json with success = 1
                $response["success"] = 1;
                $response["id"] = $user["id"];

                $response["username"] = $user["unique_id"];
                $response["email"] = $user["email"];
                $response["age"] = $user["age"];
                $response["sex"] = $user["sex"];
                $response["created"] = $user["created_at"];
                $response["updated"] = $user["updated_at"];
                sendResponse(200,json_encode($response));
            } else {
                // user not found
                // echo json with error = 1
                $response["$name"] = $name;
                $response["$password"] = $password;

                $response["error"] = 1;
                $response["error_msg"] = "Incorrect username or password!";
                sendResponse(4030,json_encode($response));
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
                    
                    
                    
                    if ((($_FILES["file"]["type"] == "image/gif")
                         || ($_FILES["file"]["type"] == "image/jpeg")
                         || ($_FILES["file"]["type"] == "image/pjpeg"))
                        && ($_FILES["file"]["size"] < 2000000))
                    {
                        if ($_FILES["file"]["error"] > 0)
                        {
                            $response["error"] = 1;
                            $response["error_msg"] = "Return Code: " . $_FILES["file"]["error"];
                            
                            sendResponse(2004,json_encode($response));

                            
                        }
                        else
                        {
//                            $response["success"] = 1;
                            $response["Upload"] = $_FILES["file"]["name"];
                            $response["Type"] = $_FILES["file"]["type"];
                            $response["Size"]= ($_FILES["file"]["size"] / 1024);
                            $response["Temp file"] = $_FILES["file"]["tmp_name"];
      
//                            if (file_exists(getcwd() ."/upload/"))
//                            {
//                                $response["errorPath"] = "upload  exists.";
//                                sendResponse(2010,json_encode($response));
//                                
//                            }
                            if(!is_writable(getcwd() ."/upload/") )
                            {
                                $response["errorPath"] = "upload  is not writable.";

                            }


                            if (file_exists(getcwd() ."/upload/" . $_FILES["file"]["name"]))
                            {
                                $response["error"] = $_FILES["file"]["name"] . " already exists.";
                                
                            }
                            else
                            {
                                $moved = move_uploaded_file($_FILES["file"]["tmp_name"],
                                                   getcwd() ."/upload/" . $_FILES["file"]["name"]);
                                if($moved)
                                {
                                    $response["NoError"] = "Stored in: " . getcwd() . "/upload/" . $_FILES["file"]["name"];
                                }
                                else
                                {
                                
                                    $response["errorUploading"] = "Return Code: " . $_FILES["file"]["error"];

                                }
                                
                                
                            }
                        }
                    }
                    
                    
                    
                    
                    
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

    
    
//    
//    
//    $response = array("tag" => $tag, "success" => 0, "error" => 0);
//
//    
//    
//    
//    
//    if ((($_FILES["file"]["type"] == "image/gif")
//         || ($_FILES["file"]["type"] == "image/jpeg")
//         || ($_FILES["file"]["type"] == "image/pjpeg"))
//        && ($_FILES["file"]["size"] < 20000))
//    {
//        if ($_FILES["file"]["error"] > 0)
//        {
//            $response["error"] = 1;
//            $response["error_msg"] = "Return Code: " . $_FILES["file"]["error"];
//            
//        }
//        else
//        {
//            $response["success"] = 1;
//            $response["Upload"] = $_FILES["file"]["name"];
//            $response["Type"] = $_FILES["file"]["type"];
//            $response["Size"]= ($_FILES["file"]["size"] / 1024);
//            $response["Temp file"] = $_FILES["file"]["tmp_name"];
//            sendResponse(200,json_encode($response));
////            echo "Upload: " . $_FILES["file"]["name"] . "<br />";
////            echo "Type: " . $_FILES["file"]["type"] . "<br />";
////            echo "Size: " . ($_FILES["file"]["size"] / 1024) . " Kb<br />";
////            echo "Temp file: " . $_FILES["file"]["tmp_name"] . "<br />";
//            
//            if (file_exists("upload/" . $_FILES["file"]["name"]))
//            {
//                $response["error"] = $_FILES["file"]["name"] . " already exists.";
//                sendResponse(2010,json_encode($response));
//
//            }
//            else
//            {
//                move_uploaded_file($_FILES["file"]["tmp_name"],
//                                   "upload/" . $_FILES["file"]["name"]);
//                $response["error"] = "Stored in: " . "upload/" . $_FILES["file"]["name"];
//                sendResponse(2002,json_encode($response));
//
//
////                echo "Stored in: " . "upload/" . $_FILES["file"]["name"];
//            }
//        }
//    }
//    else
//    {
//        echo "Invalid file";
   
//    }
?>
