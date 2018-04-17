
<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/clientes/clientes.php"); ?>
<?php 
$us=$_POST['u'];
$id=$_POST['i'];
$p = new Cliente();
 $result=$p->delete_cliente($us,$id); 
 echo $result[0]; 

 ?>