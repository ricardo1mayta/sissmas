 <?php  
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/productos/producto.php"); ?>
<label>Producto</label>

<select class="form-control" name="detalle" id="detalle" >
	<option value="">----Selecciones---</option>
	<?php
	
	$id=$_GET['id'];
	$cate = new Productos();
	$categoria=$cate->get_Iddetalle($id);
	while($cat=$categoria->fetch_array()){   
	?>
	<option value="<?php echo $cat['DPRO_C_CODIGO']?>|<?php echo $cat['DPRO_D_NOMBRE']?>"><?php echo $cat['DPRO_D_NOMBRE']?></option>
	<?php }?>
</select>



