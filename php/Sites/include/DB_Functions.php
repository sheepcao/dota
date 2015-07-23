<?php

class DB_Functions {

    private $db;

    //put your code here
    // constructor
    function __construct() {
        require_once 'DB_Connect.php';
        // connecting to database
        $this->db = new DB_Connect();
        $this->db->connect();
    }

    // destructor
    function __destruct() {
        
    }

    /**
     * Storing new user
     * returns user details
     */
    public function storeUser($name, $email, $password, $age, $sex) {

		$result = mysql_query("INSERT INTO userinfo(unique_id, email, password, age, sex, created_at) VALUES('$name', '$email', '$password', '$age','$sex', NOW())");
        // check for successful store
        if ($result) {
            // get user details 
            $result = mysql_query("SELECT * FROM userinfo WHERE unique_id = \"$name\"");
            // return user details
            return mysql_fetch_array($result);
        } else {
            return false;
        }
    }

    /**
     * Get user by email and password
     */
    public function getUserByNameAndPassword($name, $password) {
        $result = mysql_query("SELECT * FROM userinfo WHERE unique_id = '$name'") or die(mysql_error());
        // check for result 
        $no_of_rows = mysql_num_rows($result);
        if ($no_of_rows > 0) {
            $result = mysql_fetch_array($result);
            $passwordInDB = $result['password'];

            // check for password equality
            if ($passwordInDB == $password) {
                // user authentication details are correct
                return $result;
            }
        } else {
            // user not found
            return false;
        }
    }

    /**
     * Check user is existed or not
     */
    public function isUserExisted($name) {
        $result = mysql_query("SELECT * from userinfo WHERE unique_id = '$name'");
        $no_of_rows = mysql_num_rows($result);
        if ($no_of_rows > 0) {
            // user existed 
            return true;
        } else {
            // user not existed
            return false;
        }
    }
    


    /**
     * Get playerInfo by name
     */
    public function getUserInfoByName($name) {
        $result = mysql_query("SELECT * FROM userinfo u left join levelinfo l on l.username = u.unique_id WHERE unique_id = '$name'") or die(mysql_error());
        // check for result
        $no_of_rows = mysql_num_rows($result);
        if ($no_of_rows > 0) {
            $result = mysql_fetch_array($result);
            return $result;
        }else {
        // user not found
        return $result;
        }
    }

    /**
     * Storing signature
     * returns signature
     */
    public function storeSignature($content,$username)
    {
        
        $userResult = mysql_query("SELECT * FROM signatureinfo WHERE username = '$username'") or die(mysql_error());

        $no_of_rows = mysql_num_rows($userResult);
        $response["error"] = $no_of_rows;

        if ($no_of_rows > 0) {
            
            $update = mysql_query("update signatureinfo set content = '$content' where username = '$username'") or die(mysql_error());
            
            if($update)
            {
                
                $result = mysql_query("SELECT * FROM signatureinfo WHERE username = '$username'") or die(mysql_error());
                if ($result)
                {
                    return mysql_fetch_array($result);
                    
                }else
                {
                    return false;
                }
            }else
            {
                return false;
            }

            
        } else {
            
            
            $insert = mysql_query("INSERT INTO signatureinfo(username, content) VALUES('$username', '$content')") or die(mysql_error());
            if ($insert)
            {
                $result = mysql_query("SELECT * FROM signatureinfo WHERE username = '$username'") or die(mysql_error());
                if ($result)
                {
                    return mysql_fetch_array($result);
                    
                }else
                {
                    return false;
                }
            }else
            {
                return false;
            }
            
        }
        
        
        
    }
    
    /**
     * get signature
     * returns signature
     */
    
    
    public function fetchSignature($username) {
        $result = mysql_query("SELECT * FROM signatureinfo WHERE username = '$username'") or die(mysql_error());
        // check for result
        $no_of_rows = mysql_num_rows($result);
        if ($no_of_rows > 0) {
            $result = mysql_fetch_array($result);
            return $result;
        }else {
            // signature not found
            return false;
        }
    }

    
    /**
     * Storing level
     *
     */
    public function registerLevel($username)
    {
        $isReviewed = "no";

        
        $userResult = mysql_query("SELECT * FROM levelinfo WHERE username = '$username'") or die(mysql_error());
        
        $no_of_rows = mysql_num_rows($userResult);
        
        if ($no_of_rows > 0) {
            
            
            $update = mysql_query("update levelinfo set isReviewed ='$isReviewed', created_Time = NOW() where username = '$username'") or die(mysql_error());
            
            if($update)
            {
                
                $result = mysql_query("SELECT * FROM levelinfo WHERE username = '$username'") or die(mysql_error());
                if ($result)
                {
                    return mysql_fetch_array($result);
                    
                }else
                {
                    return false;
                }
            }else
            {
                return false;
            }
            
            
        } else {
            
            
            $insert = mysql_query("INSERT INTO levelinfo(username, isReviewed,created_Time) VALUES('$username', '$isReviewed',NOW())") or die(mysql_error());
            if ($insert)
            {
                $result = mysql_query("SELECT * FROM levelinfo WHERE username = '$username'") or die(mysql_error());
                if ($result)
                {
                    return mysql_fetch_array($result);
                    
                }else
                {
                    return false;
                }
            }else
            {
                return false;
            }
            
        
        }
    }
    
    /**
     * get Reviews
     * returns Reviews
     */
    
    
    public function fetchAllReviews($reviewStatus) {

        $result = mysql_query("SELECT * FROM levelinfo WHERE isReviewed = '$reviewStatus'") or die(mysql_error());
        // check for result
        $no_of_rows = mysql_num_rows($result);
        if ($no_of_rows > 0) {
            return $result;
        }else {
            // user not found
            return false;
        }
    }
    
    public function updateUserLevel($username,$isReviewed,$gameID,$JJCscore,$TTscore,$ratio,$soldier,$heroFirst,$heroSecond,$heroThird) {
        
        $result = mysql_query("SELECT * FROM levelinfo WHERE username = '$username'") or die(mysql_error());
        // check for result
        $no_of_rows = mysql_num_rows($result);
        if ($no_of_rows > 0) {
            
            
            $update = mysql_query("update levelinfo set isReviewed ='$isReviewed',gameID = '$gameID', JJCscore = '$JJCscore', TTscore = '$TTscore', WinRatio = '$ratio',soldier = '$soldier', heroFirst = '$heroFirst', heroSecond = '$heroSecond', heroThird = '$heroThird' where username = '$username'") or die(mysql_error());
            
            if($update)
            {
                
                $result = mysql_query("SELECT * FROM levelinfo WHERE username = '$username'") or die(mysql_error());
                if ($result)
                {
                    return mysql_fetch_array($result);
                    
                }else
                {
                    return false;
                }
            }else
            {
                return false;
            }
            

        }else {
            // user not found
            return false;
        }
    }
    

}

?>
