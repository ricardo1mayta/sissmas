<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/almacen/almacen.php"); ?>
<?php 
 $us=$_GET['u'];

 $idven=$_GET['idven'];
$p = new Almacen();
$result=$p->despachar($idven,$us); 
echo $result[0];
?>