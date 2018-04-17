 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/compras/compras.php"); ?>
<?php 
$sede=$_GET['s'];
$t=$_GET['t'];
$p = new Compras();
 $result=$p->get_comprastipodespacho($sede,$t);
  
  while($lista=$result->fetch_array()){                        
     ?>
     <tr id="sell<?=$lista[0]?>" >
       <td><?php echo $lista['T_C_CODIGO']. substr(('00000000'.$lista['C_C_CODIGO']), -8,8); ?></td>
       <td><?php echo $lista['PV_D_NOMBRES'] ?></td>
        <td><?php echo $lista['PV_C_DOC'] ?></td>
        <td><?php echo $lista['PV_D_DIRECCION'] ?></td>
       <td><?php echo $lista['AUD_F_FECHAINSERCION'] ?></td>
       <td><?php echo $lista['MONEDA'].$lista['TOTAL'] ?></td>
       <td><button type="button" class="btn btn-primary btn-xs" data-toggle="modal" data-target="#myModal" data-id="<?=$lista['C_C_CODIGO']?>" data-nom="<?=$lista['PV_D_NOMBRES']?>" data-toggle="tooltip" title="Detalle"><i class="fa fa-mail-forward"></button></td>  
       <td><button type="button" class="btn btn-success btn-xs" data-toggle="modal" data-target="#tipopago" data-id="<?=$lista[0]?>" data-nom="<?=$lista[1]?>" data-toggle="tooltip" title="Detalle"><i class="fa fa-mail-forward">Al Contado</button></td>
       <td><button type="button" class="btn btn-warning btn-xs" data-toggle="modal" data-target="#acredito" data-id="<?=$lista[0]?>" data-nom="<?=$lista[1]?>" data-toggle="tooltip" title="Detalle"><i class="fa fa-mail-forward">A Credito</button></td>

     
      <!-- <td onclick="anular(<?=$lista['C_C_CODIGO']?>)"><i class="fa fa-ban"  data-toggle="tooltip" title="Anular"></i></td>-->
       
     </tr>
     <?php } ?>