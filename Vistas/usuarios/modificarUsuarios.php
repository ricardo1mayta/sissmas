<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>
<?php include_once(HTML_DIR . '/template/header_menu.php'); ?>
<?php  

   ?>
  <div class="content-wrapper" >
	  <div class="content">
     
	  	<?php   include_once(HTML_DIR .'usuarios/opcionesUsuarios.php');?>
        <div class="box">
        <div class="box-header with-border">
          <h3 class="box-title">Agregar Usuarios</h3>

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
              <form role="form" name="form1" action="../listarUsuarios/" method="POST" enctype="multipart/form-data">
                  <div class="box-body">
                      
                          <div class="form-group col-md-3">
                            <label>Nombre</label>
                            <input type="hidden"   name="evento"  value="actualizar">
                            <input type="hidden"   name="codigo"  value="<?php echo $codigo;?>">
                            <input type="text" class="form-control"  name="nombre" id="nombre" value="<?php echo $nombre;?>" required>
                          </div>
                          <div class="form-group col-md-3">
                            <label>Apellidos</label>
                            <input type="text" class="form-control"  name="apell" id="apell"  value="<?php echo $apell;?>"  required>
                          </div>
                          <div class="form-group col-md-3">
                            <label>Correo</label>
                            <input type="email" class="form-control"  name="correo" id="correo"  value="<?php echo $correo;?>"  required>
                          </div>
                          <div class="form-group col-md-3">
                            <label>Password</label>
                            <input type="Password" class="form-control"  name="pass" id="pass" value="<?php echo $pass;?>"   required>
                          </div>
                          <div class="form-group col-md-3">
                            <label>Categoria </label>
                             <select class="form-control" name="sede" id="sede">
                             <option value="<?php echo $idsede;?>"><?php echo $sede;?></option>
                              <?php 
                               $sedes = new Sedes();
                               $sede=$sedes->get_allSedes();
                               while($cat=$sede->fetch_array()){

                                   ?>
                                        
                                        <option value="<?php echo $cat['SED_C_CODIGO']?>"><?php echo $cat['SED_D_NOMBRE']?></option>
                                                   
                                <?php }?>
                              </select>
                          </div>
                          <div  class="form-group col-md-4">
                            <br />
                             <input type="file" id="files" class="filestyle"  name="img"/>
                                <input type="hidden" name="imgmod" value="<?php echo $img;?>"/>
                               
                           </div>
                           <div  class="form-group col-md-3">
                             
                                <output id="list"  ><img class="thumb" src="<?php echo "../Public/img/Usuarios/".$img; ?>" title="" width="50" height="50"/> </output>

                                 
                           </div>
                          <div class="box-footer col-md-2">
                               <button type="submit" class="btn btn-primary">Actualizar</button> 
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
