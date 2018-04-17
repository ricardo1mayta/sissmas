 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ventas/ventas.php"); ?>

<?php 
$sede=$_GET['s'];
$t=$_GET['t'];
$p = new Ventas();
 $result=$p->credito($t,$sede);
  echo $result[0];
 ?>