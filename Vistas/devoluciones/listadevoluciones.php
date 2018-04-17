<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/gastos/gastos.php"); 

$idus = $_GET['u'];
$pro = new Gastos();
$total=0;
                         $result=$pro->get_gastos($idus) ;
                         while($lista=$result->fetch_array()){
                        $total= $lista['GAS_N_MONTO'];                        
                             ?>
                             <tr>
                               <td><?=$lista['TGA_D_NOMBRE']?></td>
                               <td><?=$lista['GAS_N_MONTO']?></td>
                                <td><?=$lista['GAS_D_DESCRIPCION']?></td>

                             </tr>
                             <?php 

                           }
?>
<tr style="color:red;font-style: bold; background-color:#C3C2C2">
	<td>Total</td>
	<td><?=$total?></td>
</tr>