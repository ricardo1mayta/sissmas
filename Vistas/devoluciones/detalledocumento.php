<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/devoluciones/devoluciones.php"); 
?>
<?php 
$num=$_GET['num'];
$sed=$_GET['dc'];
if($num!=''){
$det=new Devoluciones();
$fila=$det->get_cliente();

 ?>
<div class="form-group col-md-2">
  <label class="control-label ">Cliente</label>                
  <input type="text" class="form-control" id="" name="monto" value="<?=$fila[0]?>" disabled>                  
</div>
<div class="form-group col-md-2">
  <label class="control-label ">Fecha</label>                
  <input type="text" class="form-control" id="monto" name="monto" value="<?=$fila[1]?>" disabled>                  
</div>
<div class="form-group col-md-2">
  <label class="control-label ">Sede</label>                
  <input type="text" class="form-control" id="monto" name="monto" value="<?=$fila[2]?>" disabled>                  
</div>
<div class="form-group col-md-2">                 
  <button style="margin-top:25px" class="btn btn-success" onclick="verproductos()">ss <?=$fila[3]?></button>                  
</div>
<?php } ?>