 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/compras/compras.php"); ?>

<?php 
$sede=$_GET['s'];
$t=$_GET['t'];
$fv=$_GET['fv'];
$p = new Compras();
 $result=$p->deuda($t,$sede,$fv);
  echo $result[0];

 ?>