 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/pedidos/pedidos.php"); ?>

<?php 
$sede=$_GET['s'];
$p = new Pedidos();
 $result=$p->get_pedidos($sede);
  setlocale(LC_MONETARY, 'en_US');
  while($lista=$result->fetch_array()){                        
     ?>
     <tr id="sell<?=$lista[0]?>" >
      
       <td><?php echo 'PED-'. substr(('00000000'.$lista['PED_C_CODIGO']), -8,8); ?></td>
       <td><?php echo $lista['CLIENTE'] ?></td>
       <td><?php echo $lista['CLI_D_DOC'] ?></td>
       <td><?php echo ''.$lista['TOTAL'] ?></td>
       <td><button type="button" class="btn btn-primary btn-xs" data-toggle="modal" data-target="#myModal" data-id="<?=$lista[0]?>" data-nom="<?=$lista[1]?>" data-toggle="tooltip" title="Detalle"><i class="fa fa-mail-forward"></button></td>      
       
       <td onclick="vender(<?=$lista[0]?>,'<?=md5($lista[0])?>','F')"><i class="fa fa-building-o"  data-toggle="tooltip" title="Vender"></i>FACTURA</td>
       <td onclick="vender(<?=$lista[0]?>,'B')"><i class="fa fa-building-o"  data-toggle="tooltip" title="Vender"></i>BOLETA</td>
       <td onclick="vender(<?=$lista[0]?>,'P')"><i class="fa fa-building-o"  data-toggle="tooltip" title="Vender"></i>PROFORMA</td>
       <td onclick="eliminapedido(<?=$lista[0]?>)"><i class="fa  fa-trash"  data-toggle="tooltip" title="Dar de Baja"></i></td>
       

     </tr>
     <?php } ?>