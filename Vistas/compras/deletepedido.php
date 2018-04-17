<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/pedidos/pedidos.php"); ?>
<?php 
$us=$_GET['u'];
$idped=$_GET['txt'];
$p = new Pedidos();
 $result=$p-> delete_pedido($idped,$us); 
 echo $result[0]; ?>
