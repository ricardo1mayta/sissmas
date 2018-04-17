 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/compras/compras.php"); 
include("../../Modelo/compras/detalleCompras.php"); ?>


<?php 
$i=0;
 $idpv=$_POST['idemp'];
 $us=$_POST['u'];
 $idsed=$_POST['s'];
 $tipodoc=$_POST['t'];
 $tipomoneda=$_POST['tm'];
 $tipocambio=$_POST['tc'];
 $num=$_POST['num'];
 $ar=$_POST['ar'];
 $total=$_POST['con'];
 $sms="";
 if(count($ar)>0){
	$p = new Compras();
	$idped=$p->save_compra($idpv ,$us,$idsed,$tipodoc,$num,$tipomoneda,$tipocambio);
	

	
	foreach($ar as $array)
	 	{

	 	$dp = new Detallecompras();
	 	$ms=$dp->save_detallecompra($idped[0],$array['id'],$array['cantidad'],$array['precio'],$us,$tipomoneda,$tipocambio);	 	
	 	$i++;
		$sms.=$i." ".$ms[0]." -> ";
	 	}
	 	echo 'Compra-> '.$idped[0].' : '.$sms; 
 }

 ?>

