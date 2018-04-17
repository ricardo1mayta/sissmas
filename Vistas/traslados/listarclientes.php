 
 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ordenventa/ordenventa.php"); ?>

<?php  		$txt=$_GET['txt'];
			$s=$_GET['s'];
if($txt!=""){
			$pro = new OrdenVenta();


                        $categoria=$pro->usuariossede($s,$txt);
                      
                         while($row=$categoria->fetch_array()){ 
                         $dir=$row['SED_D_NOMBRE'];
                         $nom=$row['US_D_NOMBRE'];  
                             ?>
                             <label onclick="agregar_c(<?php echo $row['US_C_CODIGO']; ?>,0,'<?=$nom; ?>','<?=$dir; ?>')"  style="cursor: pointer"><?=$row['US_D_NOMBRE']; ?></label><br>
                             
                             <?php }

                            }?>
