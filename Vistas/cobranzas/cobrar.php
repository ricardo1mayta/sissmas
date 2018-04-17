 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ventas/ventas.php"); ?>

<?php 
$u=$_GET['s'];
$t=$_GET['t'];
$tp=$_GET['tp'];
$p = new Ventas();
 $result=$p->cobrar($t,$u,$tp);
 echo $result[0];
 ?>