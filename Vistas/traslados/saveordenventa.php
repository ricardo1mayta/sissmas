 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/pedidos/pedidos.php"); 
include("../../Modelo/pedidos/detallepedidos.php"); ?>


<?php 
$i=0;
 $idemp=$_POST['idemp'];
 $us=$_POST['u'];
 $ar=$_POST['ar'];
 $s=$_POST['s'];
 $smm='';
 if(count($ar)>0){
	$p = new Pedidos();
	$idped=$p->save_pedido($idemp,$us,$s);

	foreach($ar as $array)
	 	{

	 	$dp = new DetallePedidos();
	 	$ms=$dp->save_detallepedido($idped[0],$array['id'],$array['cantidad'],$array['precio'],$us);	 	
	 	$i++;
	 	}
	 	$mss.=$ms[0]; 
 }
echo 'Pedido Creado: '.$mss;
 	
 ?>

