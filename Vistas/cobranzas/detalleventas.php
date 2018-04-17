 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/pedidos/detallepedidos.php"); ?>
<?php  $p = new DetallePedidos();
 $result=$p->get_detalleventas($_GET['txt']);
 (Double) $total=0;
 $i=1;
 setlocale(LC_MONETARY, 'en_US');
 while($lista=$result->fetch_array()){  
 $total=$total+$lista['DVE_N_SUBTOTAL'];                      
     ?>
     <tr >
     <td><?php echo $i++; ?></td>
       <td><?=$lista['DVE_D_NOMBREPRODUCTO']?></td>
       <td  >
       
       <span id="fc<?=$lista['DVE_C_CODIGO']?>"><?php echo $lista['DVE_N_CANTIDAD'] ?></span>
       </td>
       <td  >
       <span id="s<?=$lista['DVE_C_CODIGO']?>" style="display:none;" >S/. </span>
       <span id="f<?=$lista['DVE_C_CODIGO']?>"><?php echo "S/.".$lista['DVE_N_PRECIO']; ?></span>
       </td>
       <td  ><?php echo "S/.".$lista['DVE_N_SUBTOTAL']; ?></td>
      

     </tr>
     <?php } ?>
      <tr class=" bg-gray">
      <td colspan="4" ><span class="pull-right"> Total:</span></td>
      <td colspan="3" >S/.<?php echo round($total,2); ?></td>
      </tr>