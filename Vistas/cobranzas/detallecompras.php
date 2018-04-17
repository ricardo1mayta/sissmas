 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/compras/detalleCompras.php");
include("../../Modelo/almacen/almacen.php"); ?>
<?php  $p = new Detallecompras();
 $result=$p->get_detallecompras($_GET['txt']);
 (Double) $total=0;
 $i=1;
 $moneda;
 
 while($lista=$result->fetch_array()){  
 $total=$total+$lista['S_TOTAL'];                      
     ?>
     <tr >
     <td><?php echo $i++; ?></td>
       <td><a data-toggle="collapse" data-parent="#accordion" href="#collapseOne<?=$lista['COM_C_CODIGO']?>" aria-expanded="false" class="collapsed"><?php echo $lista['PRO_D_NOMBRE'].$lista['COM_C_CODIGO'] ?></a></td>
       <td  >
          <span id="fc<?=$lista['COM_C_CODIGO']?>"><?=$lista['COM_N_CANTIDAD']?></span>
       </td>
       <td><span id="f<?=$lista['COM_C_CODIGO']?>"><?=$lista['MONEDA'].$lista['COM_N_PRECIOC']?></span>
       </td>
       <td ><?php echo $lista['MONEDA'].$lista['S_TOTAL']; ?></td>
        <?php 
        $moneda=$lista['MONEDA'];
         ?>
       

     </tr>
     <tr>
       
       
     <?php } ?>
      <tr class=" bg-gray">
      <td colspan="4" ><span class="pull-right"> Total:</span></td>
      <td colspan="3" ><?php echo $moneda.round($total,2); ?></td>
      </tr>
