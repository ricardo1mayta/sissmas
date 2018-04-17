<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/provedores/provedores.php"); ?>
<?php 
$us=$_POST['u'];
$nombre=$_POST['nombre'];
$apellidos=$_POST['apellidos'];
$ruc=$_POST['ruc'];
$direccion=$_POST['direccion'];
$telefono=$_POST['telefono'];
$correo=$_POST['correo'];
$sed=$_POST['s'];
$p = new Provedores();
 $result=$p->ave_provedor($ruc,$nombre,$apellidos,$direccion,$telefono,$correo,$sed,$us); 
 echo $result[0]; 

 ?>