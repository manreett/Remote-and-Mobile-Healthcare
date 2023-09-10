/*
Description :This code defines a User class with methods for registering and logging in users, using a database connection established through db-connect.php. 
The class checks for existing usernames and email addresses, validates email addresses, and returns JSON-encoded success/failure messages for each operation.

*/
<?php
    
    include_once 'db-connect.php';
    
    class User{
        
        private $db;
        
        private $db_table = "Users";
        
        public function __construct(){
            $this->db = new DbConnect();
        }
        
        public function isLoginExist($username, $password){
            
            $query = "select * from ".$this->db_table." where username = '$username' AND password = '$password' Limit 1";
            
            $result = mysqli_query($this->db->getDb(), $query);
            
            if(mysqli_num_rows($result) > 0){
                
                mysqli_close($this->db->getDb());
                
                
                return true;
                
            }
            
            mysqli_close($this->db->getDb());
            
            return false;
            
        } public function isEmailUsernameExist($username, $email){
            
            $query = "select * from ".$this->db_table." where username = '$username' AND email = '$email'";
            
            $result = mysqli_query($this->db->getDb(), $query);
            
            if(mysqli_num_rows($result) > 0){
                
                mysqli_close($this->db->getDb());
                
                return true;
                
            }
            
            
            return false;
            
        }
        
        public function isValidEmail($email){
            return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
        }
        
        
        
        public function createNewRegisterUser($username, $password, $email){
            
                  
            $isExisting = $this->isEmailUsernameExist($username, $email);
            
            
            if($isExisting){
                
                $json['success'] = 0;
                $json['message'] = "Error in registering. Probably the username/email already exists";
            }
            
            else{
                
            $isValid = $this->isValidEmail($email);
                
                if($isValid)
                {
                $query = "insert into ".$this->db_table." (username, password, email, created_at, updated_at) values ('$username', '$password', '$email', NOW(), NOW())";
                
                $inserted = mysqli_query($this->db->getDb(), $query);
                
                if($inserted == 1){
                    
                    $json['success'] = 1;
                    $json['message'] = "Successfully registered the user";
                    
                }else{
                    
                    $json['success'] = 0;
                    $json['message'] = "Error in registering. Probably the username/email already exists";
                    
                }
                
                mysqli_close($this->db->getDb());
                }
                                   else{
                    $json['success'] = 0;
                    $json['message'] = "Error in registering. Email Address is not valid";

                
                }
                
            }
            
            return $json;
            
        }
        
        public function loginUsers($username, $password){
            
    $json = array();
            
    $query1 =  "SELECT email, username, password  FROM ".$this->db_table." WHERE username = '$username' AND password = '$password' LIMIT 1";
    $result1 = mysqli_query($this->db->getDB(), $query1);

    $query2 = "SELECT U.username, U.email, GROUP_CONCAT(E.value ORDER BY E.timestamp) AS ecg_data, GROUP_CONCAT(E.timestamp ORDER BY E.timestamp) AS ecg_timestamp 
           FROM ".$this->db_table." U 
           LEFT JOIN ECG_data E ON U.username = E.username  
           WHERE U.username = '$username' AND U.password = '$password'
           GROUP BY U.username, U.email";

    $result2 = mysqli_query($this->db->getDB(), $query2);

    $query3 = "SELECT U.username, U.email, GROUP_CONCAT(B.value ORDER BY B.timestamp) AS bpm_data, GROUP_CONCAT(B.timestamp ORDER BY B.timestamp) AS bpm_timestamp FROM  ".$this->db_table." U 
           LEFT JOIN BPM_data B ON U.username = B.username  
           WHERE U.username = '$username' AND U.password = '$password'
           GROUP BY U.username, U.email";

    $result3 = mysqli_query($this->db->getDB(), $query3);

    $query4 = "SELECT U.username, U.email, P.ir_value, P.red_value, P.timestamp AS ppg_timestamp 
           FROM ".$this->db_table." U 
           LEFT JOIN PPG_data P ON U.username = P.username  
           WHERE U.username = '$username' AND U.password = '$password'";

    $result4 = mysqli_query($this->db->getDB(), $query4);

    if(mysqli_num_rows($result1) > 0){
        $row1 = mysqli_fetch_assoc($result1);
        $email = $row1['email'];
        $username = $row1['username'];
        $password = $row1['password'];

        $row2 = mysqli_fetch_assoc($result2);
        $ecg_data = $row2['ecg_data'];
        $ecg_timestamp = $row2['ecg_timestamp'];

        $row3 = mysqli_fetch_assoc($result3);
        $bpm_data = $row3['bpm_data'];
        $bpm_timestamp = $row3['bpm_timestamp'];

        $row4 = mysqli_fetch_assoc($result4);
        $ir_value = $row4['ir_value'];
        $red_value = $row4['red_value'];
        $ppg_timestamp = $row4['ppg_timestamp'];

        $json['success'] = 1;
        $json['message'] = "Successfully logged in";
        $json['email'] = $email;
        $json['username'] = $username;
        $json['password'] = $password;
        $json['ecg_data'] = $ecg_data;
        $json['ecg_timestamp'] = $ecg_timestamp;
        $json['bpm_data'] = $bpm_data;
        $json['bpm_timestamp'] = $bpm_timestamp;
        $json['ir_value'] = $ir_value;
        $json['red_value'] = $red_value;
        $json['ppg_timestamp'] = $ppg_timestamp;

    }else{
        $json['success'] = 0;
        $json['message'] = "Incorrect details";
    }
    mysqli_close($this->db->getDb());
    return $json;
        }
    }
 ?>
