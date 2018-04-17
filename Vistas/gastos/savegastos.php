<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/gastos/gastos.php"); 


$tg= $_GET['tg']; 
$mon= $_GET['mon']; 
$desc= $_GET['desc']; 
$us= $_GET['u']; 
$sed= $_GET['sed'];
$pro = new Gastos();
 $result=$pro->save_gastos($tg,$mon,$desc,$us,$sed);
 echo $result[0];
 
 
                         
?>