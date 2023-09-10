/*
Description This PHP code defines a class DbConnect which connects to a MySQL database using credentials defined in config.php and has a public method getDb() to get the connection.
*/
<?php
    
    include_once 'config.php';
    
    class DbConnect{
        
        private $connect;
        
        public function __construct(){
        $this->connect = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
            
            if (mysqli_connect_errno()){
                echo "Unable to connect to MySQL Database: " . mysqli_connect_error();
            }
        }
        
        public function getDb(){
            return $this->connect;
        }
    }
?>
