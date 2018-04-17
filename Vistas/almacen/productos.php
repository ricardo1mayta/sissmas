<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/productos/productos.php"); ?>

<?php $idsed=$_REQUEST['s'];
$cat=$_REQUEST['cat'];
$mar=$_REQUEST['mar'];
$text=$_REQUEST['text'];
                $pro = new Productos();

                if($_REQUEST['cat']>0 and $_REQUEST['mar']>0)
                {
                   $sql = "SELECT p.PRO_C_CODIGO,p.PRO_D_NOMBRE,p.PRO_D_MODELO,p.PRO_D_DESCRIPCION,m.MAR_D_NOMBRE,c.CAT_D_NOMBRE,dp.PRO_N_STOCK,dp.PRO_N_PRECIOVENTA,p.PRO_I_IMAGEN,c.CAT_C_CODIGO,m.MAR_C_CODIGO FROM sm_productos p inner JOIN sm_categoria c on c.CAT_C_CODIGO=p.CAT_C_CODIGO INNER JOIN sm_marca m on m.MAR_C_CODIGO=p.MAR_C_CODIGO 
               inner JOIN sm_detalleproductos dp on dp.PRO_C_CODIGO=p.PRO_C_CODIGO 
          WHERE dp.SED_C_CODIGO='$idsed' and p.CAT_C_CODIGO='$cat' and p.PRO_D_NOMBRE LIKE'%$text%' and p.MAR_C_CODIGO='$mar'  ORDER BY p.PRO_C_CODIGO DESC LIMIT 30";
         


                } elseif ($_REQUEST['cat']>0 and $_REQUEST['mar']==0) {
                  $sql = "SELECT p.PRO_C_CODIGO,p.PRO_D_NOMBRE,p.PRO_D_MODELO,p.PRO_D_DESCRIPCION,m.MAR_D_NOMBRE,c.CAT_D_NOMBRE,dp.PRO_N_STOCK,dp.PRO_N_PRECIOVENTA,p.PRO_I_IMAGEN,c.CAT_C_CODIGO,m.MAR_C_CODIGO FROM sm_productos p inner JOIN sm_categoria c on c.CAT_C_CODIGO=p.CAT_C_CODIGO INNER JOIN sm_marca m on m.MAR_C_CODIGO=p.MAR_C_CODIGO 
                inner JOIN sm_detalleproductos dp on dp.PRO_C_CODIGO=p.PRO_C_CODIGO 
          WHERE dp.SED_C_CODIGO='$idsed' and p.CAT_C_CODIGO='$cat' and p.PRO_D_NOMBRE LIKE'%$text%'  ORDER BY p.PRO_C_CODIGO DESC LIMIT 30";


                } elseif ($_REQUEST['cat']==0 and $_REQUEST['mar']>0) {
                   $sql = "SELECT p.PRO_C_CODIGO,p.PRO_D_NOMBRE,p.PRO_D_MODELO,p.PRO_D_DESCRIPCION,m.MAR_D_NOMBRE,c.CAT_D_NOMBRE,dp.PRO_N_STOCK,dp.PRO_N_PRECIOVENTA,p.PRO_I_IMAGEN,c.CAT_C_CODIGO,m.MAR_C_CODIGO FROM sm_productos p inner JOIN sm_categoria c on c.CAT_C_CODIGO=p.CAT_C_CODIGO INNER JOIN sm_marca m on m.MAR_C_CODIGO=p.MAR_C_CODIGO 
                inner JOIN sm_detalleproductos dp on dp.PRO_C_CODIGO=p.PRO_C_CODIGO 
          WHERE dp.SED_C_CODIGO='$idsed' and p.MAR_C_CODIGO='$mar' and p.PRO_D_NOMBRE LIKE'%$text%'  ORDER BY p.PRO_C_CODIGO DESC LIMIT 30";

                }elseif ($_REQUEST['cat']==0 and $_REQUEST['mar']==0) {
                  echo  $sql = "SELECT p.PRO_C_CODIGO,p.PRO_D_NOMBRE,p.PRO_D_MODELO,p.PRO_D_DESCRIPCION,m.MAR_D_NOMBRE,c.CAT_D_NOMBRE,dp.PRO_N_STOCK,dp.PRO_N_PRECIOVENTA,p.PRO_I_IMAGEN,c.CAT_C_CODIGO,m.MAR_C_CODIGO FROM sm_productos p inner JOIN sm_categoria c on c.CAT_C_CODIGO=p.CAT_C_CODIGO INNER JOIN sm_marca m on m.MAR_C_CODIGO=p.MAR_C_CODIGO 
                inner JOIN sm_detalleproductos dp on dp.PRO_C_CODIGO=p.PRO_C_CODIGO 
          WHERE dp.SED_C_CODIGO='$idsed'  and p.PRO_D_NOMBRE LIKE'%$text%'  ORDER BY p.PRO_C_CODIGO DESC LIMIT 30";
                }
                         $result=$pro->get_allProductos($sql) ;
                         while($lista=$result->fetch_array()){                        
                             ?>                             
                      <tr>
                        <td><?=$lista['PRO_C_CODIGO']?></td>
                        <td><?=$lista['PRO_D_NOMBRE']?></td>
                        <td><?=$lista['PRO_D_MODELO']?></td>
                        <td><?=$lista['MAR_D_NOMBRE']?></td>
                        <td><?=$lista['CAT_D_NOMBRE']?></td>
                        <td><?=number_format($lista['PRO_N_STOCK'],0)?></td>
                        <td><?=$lista['PRO_N_PRECIOVENTA']?></td>
                        <td ><button type="button" class="btn btn-success btn-xs " data-toggle="modal" 
                         data-target="#descrip" data-desc="<?=$lista['PRO_D_DESCRIPCION']?>" data-img="<?=$lista['PRO_I_IMAGEN']?>">Ver</button></td>
                        
                       
                       
                        
                      </tr>
                  <?php 
                  } ?>