<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/clientes.php"); 
include("../../Modelo/ordenes.php"); 


$idus = $_REQUEST["id"];



// lookup all hints from array if $q is different from "" 
if ($nom !== "") { ?>
  
                      
                        <div class="col-md-12">
                          <?php 
                          $ord = new Ordenes();
                          $row=$ord->get_saveorden($idus);
                          ?>
                          Nº :<label name="idorden" id="idorden"><?php echo substr("0000000000".$row['ORD_C_CODIGO'], -10);?> </label>
                          <input type="hidden" id="codidoorden" value="<?php echo $row['ORD_C_CODIGO']?>">
                        </div>
                        
                      
               
<?php }else {
  # code...
  echo "Escriba el Nombre";
}

?>