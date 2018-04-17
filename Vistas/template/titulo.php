<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <title>Sissmas</title><?php 
  if(isset($_SESSION['usuario'])){ 
 $usuario=$_SESSION['usuario'];
} else {
	echo "<script language=Javascript> location.href=\"../\"; </script>";
}

 ?>