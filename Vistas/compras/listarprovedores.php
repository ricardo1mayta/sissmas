 
 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/provedores/provedores.php"); ?>

<?php  		$txt=$_GET['txt'];
			$u=$_GET['u'];
if($txt!=""){
			$pro = new Provedores();


                        $categoria=$pro->get_provedores($txt,$u);
                         echo $categoria->num_rows;
                         while($row=$categoria->fetch_array()){ 
                         $dir=$row['PV_D_DIRECCION'];
                         $nom=$row['PV_D_NOMBRES'];  
                             ?>
                             <label onclick="agregar_c(<?php echo $row['PV_C_CODIGO']; ?>,<?php echo $row['PV_C_DOC']; ?>,'<?=$nom; ?>','<?=$dir; ?>')"  style="cursor: pointer"><?=$row['PV_D_NOMBRES']; ?></label><br>
                             
                             <?php }

                             echo "Datos Encontrados: ".$categoria->num_rows;} ?>
