 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/compras/compras.php"); ?>

<?php 
$u=$_GET['s'];
$t=$_GET['t'];
$tp=$_GET['tp'];
$p = new Compras();
 $result=$p->pagar($t,$u,$tp);
 echo $result[0];
 ?>