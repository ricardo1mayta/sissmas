              <?php  

              require('../../config.ini.php');

              include("../../Modelo/conexion.php");

              include("../../Modelo/parametros.php"); ?>





                <label>Marca </label>

                       <select class="form-control" name="marca" id="marca" onchange="from(document.form1.marca.value,'prod','../Vistas/pedidos/select3_producto.php')" required>

                       <option value="">-----Selecciones-----</option>

                        <?php 

                        $id=$_GET['id'];

                         $cate = new Parametros();

                        $categoria=$cate->get_Idparametros($id);

                         while($cat=$categoria->fetch_array()){   

                             ?>

                                  <option value="<?php echo $cat['PAR_C_CODIGO']?>"><?php echo $cat['PAR_D_NOMBRE']?></option>

                                             

                          <?php }?>

                        </select>