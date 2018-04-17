<?php  require('../../config.ini.php');
		include("../../Modelo/conexion.php");
		include("../../Modelo/pedidos/detallepedidos.php"); ?>
<?php 
$iddetp=$_GET['txt'];
$us=$_GET['u'];
$pre=$_GET['p'];
$tipo=$_GET['t'];
	$detp=new DetallePedidos();
	if($tipo==1){
	$dp=$detp->update_precio_detallepedido($iddetp,$pre,$us);
	echo $dp[0];	
	}
	if($tipo==2){
	$dp=$detp->update_cantidad_detallepedido($iddetp,$pre,$us);
	echo $dp[0];	
	}


 ?>