 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ventas/ventas.php"); ?>

<?php 
$sede=$_GET['s'];
$t=$_GET['t'];
$p = new Ventas();
 $result=$p->get_ventastipo($sede,$t);
  setlocale(LC_MONETARY, 'en_US');
  while($lista=$result->fetch_array()){                        
     ?>
     <tr id="sell<?=$lista[0]?>" >
       <td><?php echo $lista['VEN_V_TIPO']. substr(('00000000'.$lista['VEN_V_NUMERO']), -8,8); ?></td>
       <td><?php echo $lista[1] ?></td>
       <td><?php echo $lista[2] ?></td>
       <td><?php echo $lista[3] ?></td>
       <td><?php echo $lista['VEN_F_FECHAVENTA'] ?></td>
       <td><?php echo 'S/.'.$lista['VEN_N_TOTAL'] ?></td>
       <td><button type="button" class="btn btn-primary btn-xs" data-toggle="modal" data-target="#myModal" data-id="<?=$lista[0]?>" data-nom="<?=$lista[1]?>" data-toggle="tooltip" title="Detalle"><i class="fa fa-mail-forward"></button></td>
             
       <td onclick="anular(<?=$lista[0]?>)"><i class="fa fa-ban"  data-toggle="tooltip" title="Anular"></i></td>
       
     </tr>
     <?php } ?>