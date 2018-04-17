<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>
<?php include_once(HTML_DIR . '/template/header_menu.php'); ?>
 <div class="content-wrapper" >
    <div class="content">
    
        <div class="box">
        <div class="box-header with-border">
          <h3 class="box-title">Lista de Productos<?php //echo $nomp ?></h3>

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
            <div class="box-header with-border">
             <div class="box-tools pull-right">
            
             </div>
            </div>

            <div class="box-body ">
            <div class="col-md-12">

              <div class="form-group col-md-3 ">
                  <label class="control-label ">Categoria</label>
                  
                   <select class="form-control" name="categoriap" id="categoriap">
                   <option value="0">-Seleccione-</option>
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
                <label class="control-label ">Marca</label>
                
                 <select class="form-control" name="marcap" id="marcap">
                 <option value="0">-Seleccione-</option>
                  <?php 
                   $marca = new Marca();
                   $rows=$marca->get_allmarcas($usuario['US_C_CODIGO']);
                   while($mar=$rows->fetch_array()){  
                       ?>
                            <option value="<?php echo $mar['MAR_C_CODIGO']?>"><?php echo $mar['MAR_D_NOMBRE']?></option>
                                       
                    <?php }?>
                  </select>
                  
              </div>
              <div class="form-group col-md-3">
                <label class="control-label ">Buscar</label>
                
                <input type="text" class="form-control" name="txtbuscar" id="txtbuscar">
                
                 
                  
              </div>
              <div class="form-group col-md-3">
                
                
               
                <button class="btn btn-defaul" id="btnbuscar"  style="margin-top:24px">buscar</button>
                 
                  
              </div>

            </div>
            <div class=" table table-responsive no-padding">
                <table  class="table " id="clientestable">
                <thead>
                <tr>
                  
                  
                  <th>CODIGO</th>
                  <th>NOMBRE</th>
                  <th>MODELO</th>
                 
                  <th>MARCA</th>
                  <th>CATEGORIA</th>
                  <th>Stock</th>
                  <th>P-Venta</th>
                   <th>DESCRIPCION</th>
                </tr>
                </thead>
                <tbody>
                 
                
                </tbody>
                
              </table>
            </div>           
           </div>
           </div>
          <!-- /.box -->
        </div>
        </div>
        <!-- /.box-body -->
       
        <!-- /.box-footer-->
      </div>

    </div>
</div>

<div class="modal fade" id="descrip" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">Descripcion</h4>
      </div>
      <div class="modal-body">
      <div id="imagenview" ></div>
        

              <p id="desciptio">I took this photo this morning. What do you guys think?</p>
      </div>     
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
       
        
        
      </div>
      </form>
    </div> 
  </div>
</div>


<?php  @include_once(HTML_DIR . '/template/ajustes_generales.php'); ?>
<?php @include_once(HTML_DIR . '/template/scrips.php'); ?>
<script >
  var dc=<?=$usuario['SED_C_CODIGO']?>; 
 var su=<?=$usuario['US_C_CODIGO']?>;
$(document).ready(function(){

productos(dc);
$( "#btnbuscar" ).click(function() {
 productos(dc);
});

});


 $('#descrip').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
   
    var desc = button.data('desc') 
    var img = button.data('img')
    var modal = $(this)
    modal.find('#desciptio').text('Editar a: ' + desc)       
    modal.find('#imagenview').html('<img id="imges" src="../Public/img/productos/'+img+'" alt="IMG-PRODUCTO" class="img-responsive pad"/>')
  
}) 
function productos(s){
  var cat=$("#categoriap").val();
  var mar=$("#marcap").val();
  var text=$("#txtbuscar").val();
  var url="../Vistas/almacen/productos.php";
   $.ajax({
     type: "POST",
     url: url,
     data: {s:s,cat:cat,mar:mar,text:text}, // Adjuntar los campos del formulario enviado.
                
     success: function(data)
     {
         
          
             $('#clientestable tbody').html(data);
          

     }
   });
}




</script>
<?php @include_once(HTML_DIR . '/template/inferior_depues_cuerpo.php'); ?>
