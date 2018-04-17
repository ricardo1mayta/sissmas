 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ventas/ventas.php"); ?>

<?php 
$sede=$_GET['s'];
$t=$_GET['t'];
$p = new Ventas();
 $result=$p->get_ventastipodespacho($sede,$t);
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
       <td><button type="button" class="btn btn-primary btn-xs" data-toggle="modal" data-target="#myModal" data-id="<?=$lista['VEN_C_CODIGO']?>" data-nom="<?=$lista[1]?>" data-toggle="tooltip" title="Detalle"><i class="fa fa-mail-forward"></button></td>
       <td><button type="button" class="btn btn-primary btn-xs" onclick="despachar(<?=$lista['VEN_C_CODIGO']?>)"><i class="fa fa-mail-forward">Despachar</button></td>
             
       <td >
         <form action="../giaDespacho/" method="POST"> 
          <input type="hidden" name="id" value="<?=$lista[0]?>">
          <input type="hidden" name="nom" value="<?=$lista[1]?>">        
          <button type="submit" >Detalle</button>
         </form>
       </td>
       
     </tr>
     <?php } ?>