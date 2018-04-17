 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/creditos/creditos.php"); ?>

<?php 
date_default_timezone_set("America/Lima");
$hoy=date('Y-m-d');

$sede=$_GET['s'];

$p = new Creditos();
 $result=$p->get_creditos($sede);
 
  while($lista=$result->fetch_array()){                        
     ?>
     <tr id="sell<?=$lista[0]?>" >
       <td><?php echo $lista['CV_C_CODIGO']; ?></td>
       <td><?php echo $lista['CLI_D_NOMBRE'] ?></td>
       <td><?php echo "S/. ".$lista['CV_N_TOTAL'] ?></td>
       <td><?php echo "S/. ".$lista['CV_N_CANCELA'] ?></td>
       <td><?php echo $lista['CV_F_FECHACREA'] ?></td>
        <?php 
               
        $fin=date($lista['CV_F_FECHAVENCE']);
        if($hoy<$fin){
          echo " <td style='background-color: green; color:white'>Vence: ".$fin."</td>";
        } else if ($hoy==$fin) {
          echo "<td style='background-color: orange; color:white'>Venciendo: ".$fin."</td>";
        } else{
           echo "<td style=' background-color: red; color:white'>Vencido: ".$fin."</td>";
        }

         ?>
       
       <td> 
       <form action="../listaVentas/" method="POST">
       <input type="hidden" name="idcre" value="<?=$lista['CV_C_CODIGO']?>">
        <input type="hidden" name="cliente" value="<?=$lista['CLI_D_NOMBRE']?>">
        <button type="submit" class="btn btn-primary btn-xs" ><i class="fa fa-mail-forward"></i></button>
       </form>
       </td>  
       <td>
       <form action="../listaPagos/" method="POST">
       <input type="hidden" name="idcre" value="<?=$lista['CV_C_CODIGO']?>">
        <input type="hidden" name="cliente" value="<?=$lista['CLI_D_NOMBRE']?>">
        <button type="submit" class="btn btn-primary btn-xs" >Pagos</button>
       </form>
       </td>
       <td><button type="button" class="btn btn-primary btn-xs" data-toggle="modal" data-target="#myModalpagos" data-id="<?=$lista[0]?>"  data-nom="<?=$lista['CLI_D_NOMBRE']?>" data-total="<?=$lista['CV_N_TOTAL']?>" data-cancela="<?=$lista['CV_N_CANCELA']?>">Abonar</button></td>
       <td onclick="finalizar(<?=$lista[0]?>,<?=$lista['CV_N_TOTAL']?>,<?=$lista['CV_N_CANCELA']?>)">Finalizar</button></td> 
       
       
     </tr>
     <?php } ?>