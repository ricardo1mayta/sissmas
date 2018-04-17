<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/clientes.php"); 
include("../../Modelo/ordenes.php"); 


$idus = $_REQUEST["id"];
$idcli = $_REQUEST["id2"];
$idor = $_REQUEST["id3"];


// lookup all hints from array if $q is different from "" 
if ($nom !== "") { ?>
  
                 <?php 
                         $cli = new Clientes();
                         $lista=$cli->get_idclientes($idus,$idcli);
                          $cli2 = new Ordenes();
                         $lista2=$cli2->get_cliorden($idcli,$idor);
                        ?>
       
            
                        <div class="col-md-8">
                          <input type="hidden" name="idcliente" value="<?php echo $lista['CLI_C_CODIGO']?>">
                          Nombre o Razon Social<label><?php echo ":  ".$lista['CLI_D_NOMBRE']." ".$lista['CLI_D_APELLIDOS']?></label>
                        </div>
                        <div class="col-md-4">
                          Ruc<label><?php echo ":  ".$lista['CLI_D_DOC']?></label>
                        </div>
                        <div class="col-md-8">
                         Direccion<label><?php echo ":  ".$lista['CLI_D_DIRECCION']?></label>
                        </div>
                         <div class="col-md-4">
                         Actualizado:<label><?php echo ":  ".$lista2['sms']?></label>
                        </div>
             
                
               
<?php }else {
  # code...
  echo "Escriba el Nombre";
}

?>