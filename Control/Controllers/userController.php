
<?php 

$user = new User();

$email=$_POST["email"];
$pass=$_POST["pass"];

$login = $user->check_login($email, $pass);
    if ($login>0) {
    
        echo "<script language=Javascript> location.href=\"../principal/\"; </script>";
    } else {
        
 	echo "<script language=Javascript> location.href=\"../\"; </script>";
     
    }


 ?>