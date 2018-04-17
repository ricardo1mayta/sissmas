<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/provedores/provedores.php"); ?>
<?php 
$us=$_POST['u'];
$nombre=$_POST['nombre'];
$ruc=$_POST['ruc'];
$direccion=$_POST['direccion'];
$telefono=$_POST['telefono'];
$correo=$_POST['correo'];
$sed=$_POST['s'];
$p = new Provedores();
 $result=$p->save_provedor($nombre,$ruc,$direccion,$telefono,$correo,$us,$sed); 
 echo $result[0]; 

 ?>