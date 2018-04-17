<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/productos/productos.php"); ?>
<?php 

$idpro=$_POST['i'];
$us=$_POST['u'];
$prod=new Productos();
$u=$prod->delete_producto($idpro,$us);
echo $u[0];
?>