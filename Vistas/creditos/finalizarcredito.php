 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/creditos/creditos.php"); ?>

<?php 
$us=$_GET['u'];

$idcre=$_GET['i'];

$p = new Creditos();
 $result=$p->finalizar($idcre,$us);
 echo $result[0];
 ?>