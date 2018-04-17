 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/pedidos/pedidos.php"); ?>

<?php 
$us=$_GET['u'];
$p = new Pedidos();
 $result=$p->get_pedidos($us);
  setlocale(LC_MONETARY, 'en_US');
  while($lista=$result->fetch_array()){                        
     ?>
     <tr id="sell<?=$lista[0]?>" >
       <td><?php echo 'PED-'. substr(('00000000'.$lista[0]), -8,8); ?></td>
       <td><?php echo $lista[1] ?></td>
       <td><?php echo $lista[2] ?></td>
       <td><?php echo money_format('%.2n',  round($lista['TOTAL'], 2));  ?></td>
       <td  onclick="verdetallepedido(<?=$lista[0]?>,<?=$lista[0]?>,'<?=$lista[1]?>')"><i class="fa fa-mail-forward"   data-toggle="tooltip" title="Detalle"></i></td>
       <td onclick="eliminapedido(<?=$lista[0]?>)"><i class="fa fa-thumbs-down"  data-toggle="tooltip" title="Dar de Baja"></i></td>

     </tr>
     <?php } ?>