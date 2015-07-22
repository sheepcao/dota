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

		$result = mysql_query("INSERT INTO users(unique_id, email, password, age, sex, created_at) VALUES('$name', '$email', '$password', '$age','$sex', NOW())");
        // check for successful store
        if ($result) {
            // get user details 
            $result = mysql_query("SELECT * FROM users WHERE unique_id = \"$name\"");
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
        $result = mysql_query("SELECT * FROM users WHERE name = '$name'") or die(mysql_error());
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
        $result = mysql_query("SELECT name from users WHERE name = '$name'");
        $no_of_rows = mysql_num_rows($result);
        if ($no_of_rows > 0) {
            // user existed 
            return true;
        } else {
            // user not existed
            return false;
        }
    }
    




}

?>
