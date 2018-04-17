<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/provedores/provedores.php"); ?>

<?php echo $s=$_REQUEST['s'];
              // echo 'us'.$user['US_C_CODIGO'];
                        $pro = new Provedores();
                         $result=$pro->get_allprovedores($s);
                         echo "hola";
                         while($lista=$result->fetch_array()){      

                             ?>
                             
                      <tr>
                        <td><?php echo $lista[0]?></td>
                        <td><?php echo $lista[1]?></td>
                        <td><?php echo $lista[2]?></td>
                        <td><?php echo $lista[3]?></td>
                        <td><?php echo $lista[4]?></td>
                        <td><?php echo $lista[5]?></td>
                        <td><button type="button" class="btn btn-primary" data-toggle="modal" 
                             data-target="#editarcliente" data-id="<?php echo $lista[0]?>" data-nombre="<?php echo $lista[1]?>"  data-ruc="<?php echo $lista[2]?>" data-direccion="<?php echo $lista[5]?>" data-telefono="<?php echo $lista[4]?>" data-correo="<?php echo $lista[3]?>">Editar</button> </td>
                         <td><button type="button" class="btn btn-danger" onclick="eliminar(<?php echo $lista[0]?>)" >Eliminar</button> </td>
                        
                      </tr>
                  <?php 
                    }
                  ?>