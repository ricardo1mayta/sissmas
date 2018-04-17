    <?php  

              require('../../config.ini.php');

              include("../../Modelo/conexion.php");

              include("../../Modelo/productos/producto.php"); ?>





                <label>Producto </label>

                       <select class="form-control" name="prod" id="prod" onchange="from(document.form1.prod.value,'detalle','../Vistas/pedidos/select4_detalle.php')">

                       <option value="">----Selecciones---</option>

                        <?php 

                        $id=$_GET['id'];

                         $cate = new Productos();

                        $categoria=$cate->get_Idproductos($id);

                         while($cat=$categoria->fetch_array()){   

                             ?>

                              <option value="<?php echo $cat['PRO_C_CODIGO']?>"><?php echo $cat['PRO_D_NOMBRE']?></option>

                                             

                          <?php }?>

                        </select>





