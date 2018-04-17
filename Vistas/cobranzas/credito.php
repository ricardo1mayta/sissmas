 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ventas/ventas.php"); ?>

<?php 
$sede=$_GET['s'];
$t=$_GET['t'];
$fv=$_GET['fv'];
$p = new Ventas();
$result=$p->credito($t,$sede,$fv);
  echo $result[0];
 // echo "test".$sede.$t.$fv;
 ?>