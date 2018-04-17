<?php  require('../../config.ini.php');
		include("../../Modelo/conexion.php");
		include("../../Modelo/pedidos/detallepedidos.php"); ?>
<?php 
$iddetp=$_GET['txt'];
$us=$_GET['u'];
$detp=new DetallePedidos();

$dp=$detp->delete_detallepedido($iddetp,$us);
echo $dp[0];

 ?>