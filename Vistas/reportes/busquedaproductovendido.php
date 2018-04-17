 hola
 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ventas/ventas.php"); ?>
<?php 
$sede=$_REQUEST['s'];
$txt=$_REQUEST['txt'];
 
$p = new Ventas();
 $result=$p->get_serieventa($sede,$txt);

  while($lista=$result->fetch_array()){   
  $cliente=$lista['CLI_D_NOMBRE']." ".$lista['CLI_D_APELLIDOS'];                     
     ?>
     <tr >
       <td><?=$lista[0]?></td>
       <td><?=$lista['PRO_D_NOMBRE']?></td>
        <td><?=$lista[1]?></td>
        <td><?=$lista[2]?></td>
        <td><?=$lista[3]?></td>
       <td><?=$lista[4]?></td>
        <td><button data-toggle="modal" data-target="#devol" data-id="<?=$lista[0]?>" data-nom="<?=$lista['PRO_D_NOMBRE']?>" data-nomc="<?=$cliente?>"  class="btn btn-danger">Devolucion</button> </td>
      
       
      
       
     </tr>
     <?php } ?>