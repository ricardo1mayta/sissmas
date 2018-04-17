<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>
<script >
  var dc=<?=$usuario['SED_C_CODIGO']?>; 
  //var dc=$("#sede").val();

 var su=<?=$usuario['US_C_CODIGO']?>;
$(document).ready(function(){

productos();

});

 
 
function productos(){

  var url="../Vistas/gastos/listagastos.php";
   $.ajax({
     type: "GET",
     url: url,
     data: {u:su}, 
              
     success: function(data)
     {
        $('#clientestable tbody').html(data);
          
      }
   });
}

function guardar(){
    
    var tg=$("#tipogasto").val();
    var mon=$("#monto").val();
    var desc=$("#description").val();
    var url="../Vistas/gastos/savegastos.php";
   
    
if(tg>0 & mon!=""){
     
          swal({
            title: "Atención!!",
            text: "Desea Guardar?",
            type: "warning",
             confirmButtonText: "OK",
            cancelButtonText: "Cancelar",
            showCancelButton: true,
            closeOnConfirm: false,
            showLoaderOnConfirm: true,
          },
          function(){
            setTimeout(function(){
                          
                              $.ajax({
                                type: 'GET',
                                url: url,
                                data: {tg:tg,mon:mon,desc:desc,u:su,sed:dc},                        
                                success: function(data){
                                 $('#newcliente').modal('hide'); 
                                  productos(dc);
                                  swal("Ok", data, "success");
                                  $("#tipogasto").val(0);
                                  $("#monto").val('');
                                  $("#description").val('');
                                }
                              });
                          
                        
                       }, 1000);
              });
        
     }
     else
     {
       swal("Falta el ruc y nombre", "", "warning")
     }

}


</script>
<?php include_once(HTML_DIR . '/template/header_menu.php'); ?>
 <div class="content-wrapper" >
    <div class="content">
    
        <div class="box">
        <div class="box-header with-border">
          <h3 class="box-title">Lista de Productos<?php //echo $nomp ?></h3>

               

          <div class="box-tools pull-right">
                 
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
                  <label class="control-label ">Tipo Gasto</label>
                  
                   <select class="form-control" name="tipogasto" id="tipogasto">
                   <option value="0">-Seleccione-</option>
                    <?php 
                     $cate = new Gastos();

                     $ca=$cate->get_tiposgastos();
                     while($cat=$ca->fetch_array()){  
                         ?>
                              <option value="<?php echo $cat['TGA_C_CODIGO']?>"><?php echo $cat['TGA_D_NOMBRE']?></option>
                                         
                      <?php }?>
                    </select>
                    
              </div>          

              <div class="form-group col-md-3">
                <label class="control-label ">Monto S/.</label>
                
                <input type="text" class="form-control" id="monto" name="monto">
                  
              </div>
              <div class="form-group col-md-3">
                <label class="control-label ">Descripcion</label>
                <input type="text" class="form-control" id="description" name="description">
                
                  
              </div>
              <div class="form-group col-md-3">
                
                
               
                <button class="btn btn-defaul" id="" onclick="guardar()" style="margin-top:24px">AGREGAR</button>
                 
                  
              </div>

            </div>
            <div class=" table table-responsive no-padding">
                <table  class="table " id="clientestable">
                <thead>
                <tr>
                  
                  
                  <th>TIPO</th>
                  <th>MONTO</th>
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


<?php  @include_once(HTML_DIR . '/template/ajustes_generales.php'); ?>
<?php @include_once(HTML_DIR . '/template/scrips.php'); ?>

<?php @include_once(HTML_DIR . '/template/inferior_depues_cuerpo.php'); ?>
