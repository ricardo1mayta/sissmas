<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/clientes/clientes.php"); ?>
<?php 
$us=$_POST['u'];
$nombre=$_POST['nombre'];
$apellidos=$_POST['apellidos'];
$ruc=$_POST['ruc'];
$direccion=$_POST['direccion'];
$telefono=$_POST['telefono'];
$correo=$_POST['correo'];
$sed=$_POST['s'];
$p = new Cliente();
 $result=$p->save_cliente($ruc,$nombre,$apellidos,$direccion,$telefono,$correo,$sed,$us); 
 echo $result[0]; 

 ?>