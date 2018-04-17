 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/compras/compras.php"); ?>
<?php 
$sede=$_REQUEST['s'];
$txt=$_REQUEST['txt'];
 
$p = new Compras();
 $result=$p->get_seriecompras($sede,$txt);

  while($lista=$result->fetch_array()){                        
     ?>
     <tr >
       <td><?=$lista[0]?></td>
       <td><?=$lista[1]?></td>
        <td><?=$lista[2]?></td>
        <td><?=$lista[3]?></td>
             
      
       
     </tr>
     <?php } ?>