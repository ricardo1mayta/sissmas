<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/almacen/almacen.php"); ?>
<?php 
$us=$_GET['u'];
$idped=$_GET['p'];
$iddped=$_GET['dp'];
$serie=$_GET['s'];
$p = new Almacen();
$result=$p->agregaserie($iddped,$idped,$us,$serie); 
echo $result[0]." ".$serie;?>
