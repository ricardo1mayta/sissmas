<?php
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/clientes.php"); 

$idus = $_REQUEST["id"];
$nom = $_REQUEST["id2"];

$hint = "";

// lookup all hints from array if $q is different from "" 
if ($nom !== "") { ?>
    <table  class="table table-hover">
                <thead>
                <tr>
                  
                  
                  
                  <th>NOMBRE</th>
                  <th>APELLIDOS</th>
                  <th>DIRECCION</th>
                   <th>RUC o DNI</th>
                   
                </tr>
                </thead>
                <tbody>
                 <?php 
                        $cli = new Clientes();
                         $result=$cli->get_nomclientes($idus,$nom) ;
                         while($lista=$result->fetch_array()){                        
                             ?>
                          
                          <tr data-dismiss="modal" onclick="nuevocliente(<?php echo $idus;?>,<?php echo $lista['CLI_C_CODIGO'];?>,'resultclientes','../Vistas/ordenes/datoscliente.php')" >
                           
                            <td><?php echo $lista['CLI_D_NOMBRE']?></td>
                            <td><?php echo $lista['CLI_D_APELLIDOS']?></td>
                            <td><?php echo $lista['CLI_D_DIRECCION']?></td>
                            <td><?php echo $lista['CLI_D_DOC']?></td>
                                                
                           
                          </tr>
                       
                  <?php 
                    }
                  ?>
                
                </tbody>
                
              </table>
<?php }else {
  # code...
  echo "Escriba el Nombre";
}

?>