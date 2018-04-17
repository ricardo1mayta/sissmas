<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/devoluciones/devoluciones.php"); 
?>
<?php 
$num=$_GET['num'];
$sed=$_GET['dc'];
if($num!=''){
$det=new Devoluciones();
$result=$det->get_productos();
?>
<table class="table">
<?php 
 while($lista=$result->fetch_array()){

 ?>
<tr>
	<td><?=$lista[0]?></td>
	<td><?=$lista[1]?></td>
	<td><?=$lista[2]?></td>
	<td><button class="btn btn-default"><?=$lista[2]?></button></td>
</tr>
<?php } 
?>
</table>
<?php
} ?>