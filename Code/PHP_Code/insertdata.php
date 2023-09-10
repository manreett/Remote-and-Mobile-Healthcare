/*Written by Manreet Kaur 

Description :This code is a PHP script for handling sensor data sent via a POST request. It includes a database connection file and defines a class called "Sensors_data" that has functions 
for inserting ECG, PPG, and BPM data into the database. The script also retrieves the user's credentials from the database and verifies the password before inserting the data. If the data
 is successfully inserted, it outputs a success message, otherwise it outputs an error message.
 */
<?php
include_once 'db-connect.php';


// Class to handle sensors data
class Sensors_data {
    private $conn;

    public function __construct() {
        $this->conn = new DbConnect();
    }

    // Function to insert BPM data into the database
    public function insertBPMData($value, $timestamp, $username) {
                    $datetime = date('Y-m-d H:i:s', strtotime($timestamp)); // Fix: Convert $timestamp to Unix timestamp

        // Construct the SQL query with a WHERE clause that filters by the logged-in user's username
            
             $sql = "INSERT INTO BPM_data (value, timestamp, username) VALUES ('$value', '$timestamp', '$username')";
       
        // Execute the query and check if successful
        if ($this->conn->getDb()->query($sql)) {
            return true;
        } else {
            return false;
        }
    }

    // Function to insert ECG data into the database
    public function insertECGData($value, $timestamp, $username) {
                        $datetime = date('Y-m-d H:i:s', strtotime($timestamp)); // Fix: Convert $timestamp to Unix timestamp

            // Construct the SQL query with a WHERE clause that filters by the logged-in user's username
        $sql = "INSERT INTO ECG_data (value, timestamp, username) VALUES ('$value', '$timestamp', '$username')";

        // Execute the query and check if successful
        if ($this->conn->getDb()->query($sql)) {
            return true;
        } else {
            return false;
        }
    }

    // Function to insert PPG data into the database
    public function insertPPGData($irValue, $redValue, $timestamp, $username) {
            $datetime = date('Y-m-d H:i:s', strtotime($timestamp)); // Fix: Convert $timestamp to Unix timestamp

// Construct the SQL query with a WHERE clause that filters by the logged-in user's username
        $sql = "INSERT INTO PPG_data (ir_value, red_value, timestamp, username) VALUES ('$irValue', '$redValue', '$timestamp', '$username')";

        // Execute the query and check if successful
        if ($this->conn->getDb()->query($sql)) {
            return true;
        } else {
            return false;
        }
    }
}

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
	$json = file_get_contents('php://input');
    $data = json_decode($json, true);

    // Retrieve the user's credentials from the database
    $username = isset($data['username']) ? $data['username'] : null;
    $password = isset($data['password']) ? $data['password'] : null;
    $db = new DbConnect();
    $result = $db->getDb()->query("SELECT * FROM Users WHERE username='$username'");
    $user = $result->fetch_assoc();
   

    // Verify the password
        if ($user && md5($password)== $user['password']) {
        // If the password is correct, insert the sensor data into the database
        $ecgValue = isset($data['ecg_value']) ? $data['ecg_value'] : null;
        $irValue = isset($data['ir_value']) ? $data['ir_value'] : null;
        $redValue = isset($data['red_value']) ? $data['red_value'] : null;  
        $bpm = isset($data['bpm']) ? $data['bpm'] : null;
        $timestamp = date('Y-m-d H:i:s', $timestamp);
    $sensors_data = new Sensors_data();
        if ($ecgValue !== null) {
            $sensors_data->insertECGData($ecgValue, $timestamp, $username);
            echo "ECG data inserted successfully.";
        }
        if ($irValue !== null && $redValue !== null) {
            $sensors_data->insertPPGData($irValue, $redValue, $timestamp, $username);
            echo "PPG data inserted successfully.";
        }
        if ($bpm !== null) {
            $sensors_data->insertBPMData($bpm, $timestamp, $username);
            echo "BPM data inserted successfully.";
        }
    } else {
        echo "Incorrect username or password.";
    }
} else {
    echo "Invalid request method.";
}
