 
 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/clientes/clientes.php"); ?>

<?php  		$txt=$_GET['txt'];
			$s=$_GET['s'];
if($txt!=""){
			$pro = new Cliente();


                        $categoria=$pro->get_clientes($txt,$s);
                         echo $categoria->num_rows;
                         while($row=$categoria->fetch_array()){ 
                         $dir=$row['CLI_D_DIRECCION'];
                         $nom=$row['NOMBRE'];  
                             ?>
                             <label onclick="agregar_c(<?php echo $row['CLI_C_CODIGO']; ?>,<?php echo $row['CLI_D_DOC']; ?>,'<?=$nom; ?>','<?=$dir; ?>')"  style="cursor: pointer"><?=$row['NOMBRE']; ?></label><br>
                             
                             <?php }

                             echo "Datos Encontrados: ".$categoria->num_rows;} ?>
