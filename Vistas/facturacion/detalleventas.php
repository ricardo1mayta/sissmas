 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ventas/ventas.php"); ?>
<?php  $p = new Ventas();
 $result=$p->get_detalleventa($_GET['txt']);
 (Double) $total=0;
 $i=1;
 setlocale(LC_MONETARY, 'en_US');
 while($lista=$result->fetch_array()){  
 $total=$total+$lista[4];                      
     ?>
     <tr >
     <td><?php echo $i++; ?></td>
       <td><?php echo $lista[1] ?></td>
       <td  >
       
       <span id="fc<?=$lista[0]?>"><?php echo $lista[2] ?></span>

       <span id="ec<?=$lista[0]?>" onclick="editc(<?=$lista[0]?>,<?=$lista[2]?>)" data-toggle="tooltip" title="Editar" class="glyphicon glyphicon-pencil pull-right"></span>

       <span id="cc<?=$lista[0]?>" style="display: none" onclick="canceleditc('<?=$lista[0]?>','<?=$lista[2]?>')" data-toggle="tooltip" title="Editar" class="glyphicon glyphicon-remove pull-right"></span>

       </td>
       <td  >
       <span id="s<?=$lista[0]?>" style="display:none;" >S/. </span>
       <span id="f<?=$lista[0]?>"><?php echo "S/.".$lista[3]; ?></span>

       <span id="e<?=$lista[0]?>" onclick="edit(<?=$lista[0]?>,<?=$lista[3]?>)" data-toggle="tooltip" title="Editar" class="glyphicon glyphicon-pencil pull-right"></span>

       <span id="c<?=$lista[0]?>" style="display: none" onclick="canceledit('<?=$lista[0]?>','<?=$lista[3]?>')" data-toggle="tooltip" title="Eliminar" class="glyphicon glyphicon-remove pull-right"></span>

       </td>
       <td  ><?php echo "S/.".$lista[4]; ?>00000</td>
       <td><i class="fa fa-close" data-toggle="tooltip" title="Eliminar" onclick="eliminarproducto(<?=$lista[0]?>,<?=$_GET['txt']?>)" ></i></i></td>
       

     </tr>
     <?php } ?>
      <tr class=" bg-gray">
      <td colspan="4" ><span class="pull-right"> Total:</span></td>
      <td colspan="3" >S/.<?php echo round($total,2); ?></td>
      </tr>