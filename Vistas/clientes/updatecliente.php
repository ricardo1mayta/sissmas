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
$id=$_POST['id'];
$p = new Cliente();
 $result=$p->update_cliente($nombre,$apellidos,$ruc,$direccion,$telefono,$correo,$us,$id); 
 echo $result[0]; 

 ?>