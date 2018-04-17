<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ventas/ventas.php"); ?>
<?php 
$us=$_GET['u'];
$idped=$_GET['txt'];
$ob=$_GET['ob'];
$p = new Ventas();
 $result=$p-> anular_venta($idped,$us,$ob); 
 echo $result[0]; ?>
