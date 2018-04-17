 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/productos/productos.php"); ?>

<?php  		$txt=$_GET['txt'];
$s=$_GET['s'];
if($txt!=""){

			$pro = new Productos();

                        $rows=$pro->get_productos($txt,$s);

                         while($row=$rows->fetch_array()){   

                             ?>
                             <label onclick="agregar(<?=$row['PRO_C_CODIGO']?>,<?=$row['PRO_N_CANTIDAD']?>,<?=$row['PRO_N_PRECIOCOMPRA']?>,<?=$row['PRO_N_PRECIOVENTA']?>,this)"  style="cursor: pointer"><?=$row['PRO_D_NOMBRE']; ?></label><br>
                             
                             <?php }
                             echo "Datos Encontrados: ".$rows->num_rows;} ?>
