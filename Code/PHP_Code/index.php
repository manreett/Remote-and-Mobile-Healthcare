/* 

Description  :This PHP code registers a new user and logs in existing users. If the user submits a registration form with a username, password, and email, the script will hash the password 
using MD5, call the createNewRegisterUser() function from the User class to create a new user in the database, and return the result in JSON format. If the user submits a login form with a
 username and password, the script will hash the password using MD5, call the loginUsers() function from the User class to authenticate the user and return the result in JSON format.*/
<?php
    
    require_once 'user.php';
    $username = "";
    
    $password = "";
    
    $email = "";
    
    if(isset($_POST['username'])){
        
        $username = $_POST['username'];
        
    }
    
    if(isset($_POST['password'])){
        
        $password = $_POST['password'];
        
    }
    
    if(isset($_POST['email'])){
        
        $email = $_POST['email'];
        
    }
            $userObject = new User();
    
    // Registration
    
    if(!empty($username) && !empty($password) && !empty($email)){
        
        $hashed_password = md5($password);
        
        $json_registration = $userObject->createNewRegisterUser($username, $hashed_password, $email);
        
        echo json_encode($json_registration);
        
    }
    
    // Login
    
    if(!empty($username) && !empty($password) && empty($email)){
        
        $hashed_password = md5($password);
        
        $json_array = $userObject->loginUsers($username, $hashed_password);
        
        echo json_encode($json_array);
    }
?>
