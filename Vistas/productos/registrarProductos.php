<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>
<?php include_once(HTML_DIR . '/template/header_menu.php'); ?>
<?php  

   ?>
  <div class="content-wrapper" >
	  <div class="content">
       <div class="box">
        <div class="box-header with-border">
          <h3 class="box-title">Agregar Productos</h3>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip" title="Collapse">
              <i class="fa fa-minus"></i></button>
            <button type="button" class="btn btn-box-tool" data-widget="remove" data-toggle="tooltip" title="Remove">
              <i class="fa fa-times"></i></button>
          </div>
        </div>
        <div class="box-body">
          
          <div class="col-md-12">
                      
          <!-- general form elements disabled -->
          <div class="box box-warning sombra">
           
            
             

              <!-- /.box-header -->
              <form role="form" name="form1" action="../registrarProductos/" method="POST" enctype="multipart/form-data">
                  <div class="box-body">
                      
                          <div class="form-group col-md-3">
                            <label>Nombre</label>
                           <input type="hidden"   value="<?php echo $usuario['US_C_CODIGO'] ?>" name="usuario"  >
                          <input type="text"  value="<?php echo $usuario['SED_C_CODIGO'] ?>" name="sede" >
                          <input type="text" class="form-control"  name="nombre" id="nombre"  required>
                          </div>
                          <div class="form-group col-md-3">
                            <label>Modelo</label>
                            <input type="text" class="form-control"  name="modelo" id="modelo"    required>
                          </div>
                          <div class="form-group col-md-3">
                            <label>Descripción</label>
                            <input type="text" class="form-control"  name="descripcion" id="descripcion"    required>
                          </div>
                           <div class="form-group col-md-3">
                            <label>Cantidad</label>
                            <input type="text" class="form-control"  name="cantidad" id="cantidad"    required>
                          </div>
                           <div class="form-group col-md-3">
                            <label>Precio Compra</label>
                            <input type="text" class="form-control"  name="preciocompra" id="preciocompra"    required>
                          </div>
                           <div class="form-group col-md-3">
                            <label>Precio venta</label>
                            <input type="text" class="form-control"  name="precioventa" id="precioventa"    required>
                          </div>
                           <div class="form-group col-md-3">
                            <label>Descuento</label>
                            <input type="text" class="form-control"  name="descuento" id="descuento"    required>
                          </div>
                           <div class="form-group col-md-3">
                            <label>Cantidad Minima</label>
                            <input type="text" class="form-control"  name="cantidadminima" id="cantidadminima"    required>
                          </div>
                          
                          <div class="form-group col-md-3">
                            <label>Categoria</label>
                             <select class="form-control" name="categoria" id="categoria">
                             <option>-Seleccione-</option>
                              <?php 
                               $cate = new Categoria();
                               $ca=$cate->get_allcategoria($usuario['US_C_CODIGO']);
                               while($cat=$ca->fetch_array()){  
                                   ?>
                                        <option value="<?php echo $cat['CAT_C_CODIGO']?>"><?php echo $cat['CAT_D_NOMBRE']?></option>
                                                   
                                <?php }?>
                              </select>
                          </div>
                           <div class="form-group col-md-3">
                            <label>Marca</label>
                             <select class="form-control" name="marca" id="marca">
                             <option>-Seleccione-</option>
                              <?php 
                               $marca = new Marca();
                               $rows=$marca->get_allmarcas($usuario['US_C_CODIGO']);
                               while($mar=$rows->fetch_array()){  
                                   ?>
                                        <option value="<?php echo $mar['MAR_C_CODIGO']?>"><?php echo $mar['MAR_D_NOMBRE']?></option>
                                                   
                                <?php }?>
                              </select>
                          </div>
                         
                          <div  class="form-group col-md-4">
                            <label>seleciona imagen</label>
                             <input type="file" id="files" class="filestyle" name="img"/>
                                
                               
                           </div>
                           <div  class="form-group col-md-3">
                             
                                <output id="list"></output>
                                 
                           </div>
                          <div class="box-footer col-md-2">
                               <button type="submit" class="btn btn-primary">Agrega Producto</button> 
                          </div>
                           
                           
                    </div>
                  <?php   if(isset($sms)) { echo $sms; $sms="";}?>
              </form>
           
           </div>
          <!-- /.box -->
        </div>
        </div>
        <!-- /.box-body -->
       
        <!-- /.box-footer-->
      </div>

	  </div>
  </div>
<script>
      function archivo(evt) {
          var files = evt.target.files; // FileList object
     
          // Obtenemos la imagen del campo "file".
          for (var i = 0, f; f = files[i]; i++) {
            //Solo admitimos imágenes.
            if (!f.type.match('image.*')) {
                continue;
            }
     
            var reader = new FileReader();
     
            reader.onload = (function(theFile) {
                return function(e) {
                  // Insertamos la imagen
                 document.getElementById("list").innerHTML = ['<img class="thumb" src="', e.target.result,'" title="', escape(theFile.name), '" width="50" height="50"/>'].join('');
                };
            })(f);
     
            reader.readAsDataURL(f);
          }
      }
     
      document.getElementById('files').addEventListener('change', archivo, false);
</script>

 <?php include_once(HTML_DIR . '/template/footer.php'); ?>
<?php include_once(HTML_DIR . '/template/ajustes_generales.php'); ?>

<?php include_once(HTML_DIR . '/template/scrips.php'); ?>
<?php include_once(HTML_DIR . '/template/inferior_depues_cuerpo.php'); ?>
