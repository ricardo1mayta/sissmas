<?php  require('../../config.ini.php');
		include("../../Modelo/conexion.php");
		include("../../Modelo/ventas/ventas.php"); ?>
<?php 
$iddetp=$_GET['txt'];
$us=$_GET['u'];
$pre=$_GET['p'];
$tipo=$_GET['t'];
	$detp=new Ventas();
	if($tipo==1){
	$dp=$detp->update_precio_detalleventa($iddetp,$pre,$us);
	echo $dp[0];	
	}
	if($tipo==2){
	$dp=$detp->update_cantidad_detalleventa($iddetp,$pre,$us);
	echo $dp[0];	
	}


 ?>