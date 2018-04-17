 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/pedidos/detallepedidos.php"); ?>
<?php  $p = new DetallePedidos();
 $result=$p->get_detallepedidos($_GET['txt']);
 (Double) $total=0;
 $i=1;
 setlocale(LC_MONETARY, 'en_US');
 while($lista=$result->fetch_array()){  
 $total=$total+$lista['SUB_TOTAL'];                      
     ?>
     <tr >
     <td><?php echo $i++; ?></td>
       <td><?php echo $lista['PRO_D_NOMBRE'] ?></td>
       <td  >
       
       <span id="fc<?=$lista['DPED_C_CODIGO']?>"><?php echo $lista['DPED_N_CANTIDAD'] ?></span>

       <span id="ec<?=$lista['DPED_C_CODIGO']?>" onclick="editc(<?=$lista['DPED_C_CODIGO']?>,<?=$lista['DPED_N_CANTIDAD']?>)" data-toggle="tooltip" title="Editar" class="glyphicon glyphicon-pencil pull-right"></span>

       <span id="cc<?=$lista['DPED_C_CODIGO']?>" style="display: none" onclick="canceleditc(<?=$lista['DPED_C_CODIGO']?>,<?=$lista['DPED_N_CANTIDAD']?>)" data-toggle="tooltip" title="Editar" class="glyphicon glyphicon-remove pull-right"></span>

       </td>
       <td  >
       <span id="s<?=$lista['DPED_C_CODIGO']?>" style="display:none;" >S/. </span>
       <span id="f<?=$lista['DPED_C_CODIGO']?>"><?php echo "S/.".$lista['DPED_N_PRECIO']; ?></span>

       <span id="e<?=$lista['DPED_C_CODIGO']?>" onclick="edit(<?=$lista['DPED_C_CODIGO']?>,<?=$lista['DPED_N_PRECIO']?>)" data-toggle="tooltip" title="Editar" class="glyphicon glyphicon-pencil pull-right"></span>

       <span id="c<?=$lista['DPED_C_CODIGO']?>" style="display: none" onclick="canceledit(<?=$lista['DPED_C_CODIGO']?>,<?=$lista['DPED_N_PRECIO']?>)" data-toggle="tooltip" title="Eliminar" class="glyphicon glyphicon-remove pull-right"></span>

       </td>
       <td  ><?php echo "S/.".$lista['SUB_TOTAL']; ?></td>
       <td><i class="fa fa-close" data-toggle="tooltip" title="Eliminar" onclick="eliminarproducto(<?=$lista['DPED_C_CODIGO']?>,<?=$_GET['txt']?>)" ></i></i></td>
       

     </tr>
     <?php } ?>
      <tr class=" bg-gray">
      <td colspan="4" ><span class="pull-right"> Total:</span></td>
      <td colspan="3" >S/.<?php echo round($total,2); ?></td>
      </tr>