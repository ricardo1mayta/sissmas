
<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/provedores/provedores.php"); ?>
<?php 
$us=$_POST['u'];
$id=$_POST['i'];
$p = new Provedores();
 $result=$p->delete_provedor($us,$id); 
 echo $result[0]; 

 ?>