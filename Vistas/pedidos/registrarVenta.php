<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ventas/ventas.php"); ?>
<?php 
$us=$_GET['u'];
$idped=$_GET['txt'];
$op=$_GET['op'];
$sede=$_GET['s'];
$p = new Ventas();
 $result=$p-> save_venta($idped,$op,$us,$sede); 
 echo $result[0];?>
