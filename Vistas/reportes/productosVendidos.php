<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>

<script >

$(document).ready(function(){

});

function buscar(c){

  var txt=$('#txtbuscar').val();
    var s=$('#idsed').val();
    
    var url="../Vistas/reportes/busquedaproductovendido.php";
if(txt!=''){
  $(c).keypress(function(e) {
    if(e.which == 13) {
        $.ajax({
               type: "POST",
               url: url,
               data: {txt:txt, s:s}, // Adjuntar los campos del formulario enviado.
                          
               success: function(data)
               {
                    $('#tablajson tbody').html(data);
               }
             });
           }
  });   
 } else {
       $('#tablajson tbody').html('');
      }  
}
 
function agregar(){
  alert()
}


</script>
<?php include_once(HTML_DIR . '/template/header_menu.php'); ?>


   <div class="content-wrapper" OnLoad='compt=setTimeout("self.close();",50)'">
    <!-- Content Header (Page header) -->
    <section class="content-header">
   
      <h1>Modulo de Reportes</h1>
     <input type="hidden" id="usco" value="<?=$user['US_C_CODIGO'] ?>">
     <input type="hidden" id="idemp" >
     
    </section>


    <!-- Main content -->
    <section class="content">
      <div class="row">
      
        <!-- left column -->
        <div class="col-md-12">
                      
          <!-- general form elements disabled -->
          <div class="box box-warning">
            <div class="box-header with-border">
              <h3 class="box-title">Busqueda del producto vendido Por Codigo de Barras</h3>
              <input type="hidden" id="idsed" value="<?=$user['SED_C_CODIGO'] ?>">
              <?php ;
              //echo convertirnumero(2123.43); ;

                ?>
              <div class="box-tools pull-right">              
               <button type="button" class="btn btn-box-tool" data-toggle="modal"  ><i class="fa fa-minus"></i> </button>
                <button type="button" class="btn btn-box-tool" data-toggle="modal"><i class="fa fa-remove"></i></button>
              </div>             
            </div>

            <div class="box-body">
            <div class="row">
        <div class="col-md-12">
          <!-- Custom Tabs -->
              <div  class="input-group col-md-12">
              <input id="txtbuscar" name="" type="text"  onkeyup="buscar(this)" class="form-control " placeholder="Search...">
                  <span class="input-group-btn">
                    <button type="submit" name="" id="" class="btn btn-flat"><i class="fa fa-search"  ></i>
                    </button>
                  </span>             
            </div>            
            <div class="table-responsive" class=" col-md-12" style="padding: 20px;">
                
                <table   class="table table-bordered table-hover" id="tablajson">
                  <thead class="bg-gray">
                    <th>Codigo-Serie-Co_barra</th>
                    <th>Producto</th>
                    <th>Fecha</th>
                    <th>Nombre </th>
                    <th>Apliidos</th>
                    <th>Estado</th>  
                    <th colspan="2"><button data-toggle="modal" data-target="#devol"  class="btn btn-danger  btn-xs">Devolucion</button></th>      
                  </thead>
                  <tbody>
                    
                  </tbody>
                  <tfoot></tfoot>
                </table>           
                
              </div>
            
            </div>
            <!-- /.tab-content -->
          </div>
          <!-- nav-tabs-custom -->
        </div>
        <!-- /.col -->

        
        <!-- /.col -->
      </div>
              
          
            </div>
              
          </div>
        </div>
       
       
        
      </div>
      <!-- /.row -->
    </section>
    <!-- /.content -->
</div>

<div class="modal fade" id="devol" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">Motivo de devolucion</h4>
      </div>
      <div class="modal-body">
          <div class="form-group">
            <label for="recipient-name" class="control-label">Serie</label>
           <input class="form-control" type="text" name="id">
          </div>
          <div class="form-group">
            <label for="recipient-name" class="control-label">Nombre Producto</label>
           <input class="form-control" type="text" name="nombre">
          </div>
          <div class="form-group">
            <label for="recipient-name" class="control-label">CLiente</label>
           <input class="form-control" type="text" name="cliente">
          </div>
           <div class="form-group">
            <label for="recipient-name" class="control-label">Motivo</label>
           <textarea class="form-control" name="decrip" id="decrip"></textarea>
          </div>
          <div class="form-group">
            <label for="recipient-name" class="control-label">Fecha Entrega</label>
           <input class="form-control" type="date" name="fecha">
          </div>
        
         
      <div class="modal-footer">
   
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" onclick="agregar()">aceptar</button>
        
        
     
      </form>
    </div> 
  </div>
</div>
</div>
</div>
          <!-- /.box-body -->
 <?php include_once(HTML_DIR . '/template/footer.php'); ?>

<?php include_once(HTML_DIR . '/template/ajustes_generales.php'); ?>

<?php include_once(HTML_DIR . '/template/scrips.php'); ?>
<script >
  
 $('#devol').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var id = button.data('id')
    var nombre = button.data('nom') 
    var nombrec = button.data('nomc') 

    var modal = $(this)
    modal.find('.modal-title').text('Editar a: ' + nombre)
    modal.find('input[name="id"]').val(id)
    modal.find('input[name="nombre"]').val(nombre)
    modal.find('input[name="cliente"]').val(nombrec)
   
    
  
}) 
</script>

  
<?php include_once(HTML_DIR . '/template/inferior_depues_cuerpo.php'); ?>
