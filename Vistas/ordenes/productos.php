<?php
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/producto.php"); 

$q = $_REQUEST["id"];

$hint = "";

// lookup all hints from array if $q is different from "" 
if ($q !== "") { ?>
    <table  class="table table-hover">
                <thead>
                <tr>
                  
                  
                  <th>CODIGO</th>
                  <th>NOMBRE</th>
                  <th>CANTIDAD</th>
                  <th>P COMPRA</th>
                  <th>P VENTA</th>
                   
                </tr>
                </thead>
                <tbody>
                 <?php 
                        $pro = new Productos();
                         $result=$pro->get_nomProductos(2,$q) ;
                         while($lista=$result->fetch_array()){                        
                             ?>
                          
                          <tr onclick="agrega(<?php echo $lista['PRO_C_CODIGO']?>,'<?php echo $lista["PRO_D_NOMBRE"]?>',<?php echo $lista['PRO_N_PRECIOVENTA']?>,<?php echo $lista['PRO_N_PRECIOCOMPRA']?>,<?php echo $lista['PRO_N_CANTIDAD']?>)">
                            <td><?php echo $lista['PRO_C_CODIGO']?></td>
                            <td><?php echo $lista['PRO_D_NOMBRE']?></td>
                            <td><?php echo $lista['PRO_N_CANTIDAD']?></td>
                            <td><?php echo $lista['PRO_N_PRECIOCOMPRA']?></td>
                            <td><?php echo $lista['PRO_N_PRECIOVENTA']?></td>
                                                
                           
                          </tr>
                       
                  <?php 
                    }
                  ?>
                
                </tbody>
                
              </table>
<?php } else {
 echo "<center><label>Ninguna Busqueda...</label></center>";
}

?>