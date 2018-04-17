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
                    $sql = "SELECT p.PRO_C_CODIGO,p.PRO_D_NOMBRE,p.PRO_D_MODELO,p.PRO_D_DESCRIPCION,m.MAR_D_NOMBRE,c.CAT_D_NOMBRE,dp.PRO_N_STOCK,dp.PRO_N_PRECIOVENTA,p.PRO_I_IMAGEN,c.CAT_C_CODIGO,m.MAR_C_CODIGO,nombresede(dp.SED_C_CODIGO) as SED_D_NOMBRE FROM sm_productos p inner JOIN sm_categoria c on c.CAT_C_CODIGO=p.CAT_C_CODIGO INNER JOIN sm_marca m on m.MAR_C_CODIGO=p.MAR_C_CODIGO 
                left JOIN sm_detalleproductos dp on dp.PRO_C_CODIGO=p.PRO_C_CODIGO 
          WHERE (p.SED_C_CODIGO='$idsed' or dp.SED_C_CODIGO='$idsed' )and p.CAT_C_CODIGO='$cat' and p.PRO_D_NOMBRE LIKE'%$text%' and p.MAR_C_CODIGO='$mar' AND p.PRO_E_ESTADO>0 ORDER BY p.PRO_C_CODIGO DESC ";
         


                } elseif ($_REQUEST['cat']>0 and $_REQUEST['mar']==0) {
                  $sql = "SELECT p.PRO_C_CODIGO,p.PRO_D_NOMBRE,p.PRO_D_MODELO,p.PRO_D_DESCRIPCION,m.MAR_D_NOMBRE,c.CAT_D_NOMBRE,dp.PRO_N_STOCK,dp.PRO_N_PRECIOVENTA,p.PRO_I_IMAGEN,c.CAT_C_CODIGO,m.MAR_C_CODIGO,nombresede(dp.SED_C_CODIGO) as SED_D_NOMBRE FROM sm_productos p inner JOIN sm_categoria c on c.CAT_C_CODIGO=p.CAT_C_CODIGO INNER JOIN sm_marca m on m.MAR_C_CODIGO=p.MAR_C_CODIGO 
                left JOIN sm_detalleproductos dp on dp.PRO_C_CODIGO=p.PRO_C_CODIGO 
          WHERE (p.SED_C_CODIGO='$idsed' or dp.SED_C_CODIGO='$idsed' ) and p.CAT_C_CODIGO='$cat' and p.PRO_D_NOMBRE LIKE'%$text%' AND p.PRO_E_ESTADO>0 ORDER BY p.PRO_C_CODIGO DESC ";


                } elseif ($_REQUEST['cat']==0 and $_REQUEST['mar']>0) {
                   $sql = "SELECT p.PRO_C_CODIGO,p.PRO_D_NOMBRE,p.PRO_D_MODELO,p.PRO_D_DESCRIPCION,m.MAR_D_NOMBRE,c.CAT_D_NOMBRE,dp.PRO_N_STOCK,dp.PRO_N_PRECIOVENTA,p.PRO_I_IMAGEN,c.CAT_C_CODIGO,m.MAR_C_CODIGO,nombresede(dp.SED_C_CODIGO) as SED_D_NOMBRE FROM sm_productos p inner JOIN sm_categoria c on c.CAT_C_CODIGO=p.CAT_C_CODIGO INNER JOIN sm_marca m on m.MAR_C_CODIGO=p.MAR_C_CODIGO 
                left JOIN sm_detalleproductos dp on dp.PRO_C_CODIGO=p.PRO_C_CODIGO 
          WHERE (p.SED_C_CODIGO='$idsed' or dp.SED_C_CODIGO='$idsed' ) and p.MAR_C_CODIGO='$mar' and p.PRO_D_NOMBRE LIKE'%$text%' AND p.PRO_E_ESTADO>0 ORDER BY p.PRO_C_CODIGO DESC ";

                }elseif ($_REQUEST['cat']==0 and $_REQUEST['mar']==0) {
                    $sql = "SELECT p.PRO_C_CODIGO,p.PRO_D_NOMBRE,p.PRO_D_MODELO,p.PRO_D_DESCRIPCION,m.MAR_D_NOMBRE,c.CAT_D_NOMBRE,dp.PRO_N_STOCK,dp.PRO_N_PRECIOVENTA,p.PRO_I_IMAGEN,c.CAT_C_CODIGO,m.MAR_C_CODIGO,nombresede(dp.SED_C_CODIGO) as SED_D_NOMBRE FROM sm_productos p inner JOIN sm_categoria c on c.CAT_C_CODIGO=p.CAT_C_CODIGO INNER JOIN sm_marca m on m.MAR_C_CODIGO=p.MAR_C_CODIGO 
                left JOIN sm_detalleproductos dp on dp.PRO_C_CODIGO=p.PRO_C_CODIGO 
          WHERE (p.SED_C_CODIGO='$idsed' or dp.SED_C_CODIGO='$idsed' )  and p.PRO_D_NOMBRE LIKE'%$text%' AND p.PRO_E_ESTADO>0 ORDER BY p.PRO_C_CODIGO DESC ";
                }
                         $result=$pro->get_allProductos($sql) ;
                         while($lista=$result->fetch_array()){                        
                             ?>                             
                      <tr>
                        <td><?=$lista['PRO_C_CODIGO']?></td>
                        <td><?=$lista['PRO_D_NOMBRE']?></td>
                        <td><?=$lista['PRO_D_MODELO']?></td>
                        <td><button type="button" class="btn btn-success btn-xs " data-toggle="modal" 
                         data-target="#descrip" data-desc="<?=$lista['PRO_D_DESCRIPCION']?>" data-img="<?=$lista['PRO_I_IMAGEN']?>">Ver</button></td>s
                        <td><?=$lista['MAR_D_NOMBRE']?></td>
                        <td><?=$lista['CAT_D_NOMBRE']?></td>
                        <td><?=$lista['SED_D_NOMBRE']?></td>
                        <td><?=number_format($lista['PRO_N_STOCK'],0)?></td>
                        <td><?=$lista['PRO_N_PRECIOVENTA']?></td>
                        
                         <td>
                           <button type="button" class="btn btn-success btn-xs " data-toggle="modal" 
                         data-target="#editarcliente" data-id="<?=$lista['PRO_C_CODIGO']?>" data-nombre="<?=$lista['PRO_D_NOMBRE']?>" data-modelo="<?=$lista['PRO_D_MODELO']?>" data-desc="<?=$lista['PRO_D_DESCRIPCION']?>" data-idcat="<?=$lista['CAT_C_CODIGO']?>" data-marca="<?=$lista['MAR_C_CODIGO']?>" data-img="<?=$lista['PRO_I_IMAGEN']?>" data-pv="<?=$lista['PRO_N_PRECIOVENTA']?>" ><i class=" fa fa-user-plus" ></i> Modificar</button>
                                             
                        </td>
                       
                        <td>
                          <button type="button" class="btn btn-danger btn-xs " onclick="eliminar(<?=$lista['PRO_C_CODIGO']?>)" ><i class=" fa fa-trash"></i>Eliminar</button>
                        </td>
                        
                      </tr>
                  <?php 
                  } ?>