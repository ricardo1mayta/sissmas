 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ordenventa/ordenventa.php"); 
include("../../Modelo/ordenventa/detalleordenventa.php"); ?>


<?php 
$i=0;
 $idus=$_POST['idemp'];
 $uscrea=$_POST['u'];
 $ar=$_POST['ar'];
 $s=$_POST['s'];
 $smm='';
 if(count($ar)>0){
	$p = new OrdenVenta();
	echo $idus."- ".$uscrea." -".$s;
	$idped=$p->save_ordenventa($idus,$uscrea,$s);

	foreach($ar as $array)
	 	{

	 	$dp = new DetalleOrdenVenta();
	 	$ms=$dp->savedetalleordenventa($idped[0],$array['id'],$array['cantidad'],$array['precio2'],$array['precio'],$s,$idus,$uscrea);	 
	 	$i++;
	 	}
	 	$mss.=$ms[0]; 
 }
echo 'Orden Generada: '.$mss;
 	
 ?>

