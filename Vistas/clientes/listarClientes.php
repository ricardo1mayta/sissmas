<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>
<?php include_once(HTML_DIR . '/template/header_menu.php'); ?>
<?php  

   ?>
  <div class="content-wrapper" >
	  <div class="content">
	  
        <div class="box">
        <div class="box-header with-border">
          <h3 class="box-title">Lista de Clientes<?php //echo $nomp ?></h3>

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
             <button type="button" class="btn btn-success" data-toggle="modal" data-target="#newcliente">
              <i class="fa fa-check"></i>Agregar</button>
          </div>
            </div>
            <div class="box-body table-responsive no-padding">
                <table  class="table " id="clientestable">
                <thead>
                <tr>
                  
                  
                  <th>CODIGO</th>
                  <th>NOMBRE</th>
                  <th>RUC</th>
                  <th>DIRECCION</th>
                   <th>TELEFONO </th>
                   <th>CORREO </th>
                </tr>
                </thead>
                <tbody>
                 
                
                </tbody>
                
              </table>
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
<div class="modal fade" id="newcliente" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">Nuevo Cliente</h4>
      </div>
      <div class="modal-body">
        <div class="col-md-12">
        <form action=""  method="post" id="nuevocliente" onsubmit="guardar(); return false;">
           <div class="form-group">
            <label for="recipient-name" class="control-label col-md-2">RUC:</label>
             <div class="form-group col-md-10">
            <input type="number" id="ruc1" name="ruc" class="form-control">
          </div>
          </div>
          <div class="form-group">
            <label for="recipient-name" class="control-label col-md-2">Nombres:</label>
              <input type="hidden" id="s" name="s" value="<?=$usuario['SED_C_CODIGO']?>" class="form-control">
              <input type="hidden" id="u" name="u" value="<?=$usuario['US_C_CODIGO']?>" class="form-control">
              <div class="form-group col-md-10">
                <input type="text" id="nombre1" name="nombre" class="form-control"> 
              </div>
                        
          </div>
          <div class="form-group">
            <label for="recipient-name" class="control-label col-md-2">Apellidos:</label>
             <div class="form-group col-md-10">
                <input type="text" id="apellidos1" name="apellidos" class="form-control">  
                </div>          
          </div>        
          <div class="form-group">
            <label for="message-text" class="control-label col-md-2">Direccion:</label>
             <div class="form-group col-md-10">
            <textarea class="form-control" name="direccion" id="direccion1"></textarea>
          </div>
          </div>
          <div class="form-group">
            <label for="recipient-name" class="control-label col-md-2">Telefono:</label>
             <div class="form-group col-md-10">
            <input type="number" id="telefono1" name="telefono" class="form-control">
          </div>
          </div>
          <div class="form-group">
            <label for="recipient-name" class="control-label col-md-2">Correo:</label>
             <div class="form-group col-md-10">
            <input type="email" id="correo1" name="correo" class="form-control">
          </div>
          </div>
       
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-default"  onclick="guardar()">Guardar</button>
        
        
      </div>
      </form>
    </div>
    </div> 
  </div>
</div>
<div class="modal fade" id="editarcliente" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">Editar Cliente</h4>
      </div>
      <div class="modal-body">
        <form action=""  method="post" id="updatecliente" onsubmit="actualizar(); return false;">
           <div class="form-group">
            <label for="recipient-name" class="control-label">RUC:</label>
            <input type="number" id="ruc" name="ruc" class="form-control">
          </div>
          <div class="form-group">
            <label for="recipient-name" class="control-label">Nombres:</label>
             <input type="hidden" id="id" name="id" class="form-control">
             <input type="hidden" id="s" name="s" value="<?=$usuario['SED_C_CODIGO']?>" class="form-control">
              <input type="hidden" id="u" name="u" value="<?=$usuario['US_C_CODIGO']?>" class="form-control">

             <input type="text" id="nombre" name="nombre" class="form-control">            
          </div>
          <div class="form-group">
            <label for="recipient-name" class="control-label">Apellidos:</label>
            <input type="text" id="apellidos" name="apellidos" class="form-control">            
          </div>        
          <div class="form-group">
            <label for="message-text" class="control-label">Direccion:</label>
            <textarea class="form-control" name="direccion" id="message-text"></textarea>
          </div>
          <div class="form-group">
            <label for="recipient-name" class="control-label">Telefono:</label>
            <input type="number" id="telefono" name="telefono" class="form-control">
          </div>
          <div class="form-group">
            <label for="recipient-name" class="control-label">Correo:</label>
            <input type="email" id="correo" name="correo" class="form-control">
          </div>
       
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" onclick="actualizar()">Actualizar</button>
        
        
      </div>
      </form>
    </div> 
  </div>
</div>
<?php @include_once(HTML_DIR . '/template/ajustes_generales.php'); ?>
<?php @include_once(HTML_DIR . '/template/scrips.php'); ?>
<script >
 var dc=<?=$usuario['SED_C_CODIGO']?>; 
 var su=<?=$usuario['US_C_CODIGO']?>;
$(document).ready(function(){

clientes(dc);

});

 $('#editarcliente').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var id = button.data('id')
    var nombre = button.data('nombre') 
    var apellidos = button.data('apellidos') 
    var ruc = button.data('ruc') 
    var direccion = button.data('direccion') 
    var telefono = button.data('telefono') 
    var correo = button.data('correo') 
    
    // Extract info from data-* attributes
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('.modal-title').text('Editar a: ' + nombre)
    modal.find('input[name="id"]').val(id)
    modal.find('input[name="nombre"]').val(nombre)
    modal.find('input[name="apellidos"]').val(apellidos)
    modal.find('input[name="ruc"]').val(ruc)
    modal.find('textarea[name="direccion"]').text(direccion)
    modal.find('input[name="telefono"]').val(telefono)
    modal.find('input[name="correo"]').val(correo)
    
  
}) 
function clientes(s){
  var url="../Vistas/clientes/clientes.php";
   $.ajax({
     type: "POST",
     url: url,
     data: {s:s}, // Adjuntar los campos del formulario enviado.
                
     success: function(data)
     {
         
          
             $('#clientestable tbody').html(data);
          

     }
   });
}
function actualizar(){
   
    var url="../Vistas/clientes/updatecliente.php";

     
          swal({
            title: "Atención!!",
            text: "Desea Actualizar?",
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
                                 type: "POST",
                                 url: url,
                                 data: $('#updatecliente').serialize(), // Adjuntar los campos del formulario enviado.
                                            
                                 success: function(data)
                                 {
                                     
                                      clientes(dc);
                                       swal("Ok", ""+data, "success")
                                      

                                 }
                               });
                          
                        
                       }, 1000);
              });
        
     

}
function guardar(){
    
    var ruc=$("#ruc1").val();
    var nom=$("#nombre1").val();
    var url="../Vistas/clientes/savecliente.php";
if(ruc!="" & nom!=""){
     
          swal({
            title: "Atención!!",
            text: "Desea Actualizar?",
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
                                 type: "POST",
                                 url: url,
                                 data: $('#nuevocliente').serialize(), // Adjuntar los campos del formulario enviado.
                                            
                                 success: function(data)
                                 {  
                                    $("#ruc1").val('');
                                    $("#nombre1").val('');
                                    $("#apellidos1").val('');
                                    $("#direccion1").val('');
                                    $("#telefono1").val('');
                                    $("#correo1").val('');
                                     $('#newcliente').modal('hide'); 
                                      clientes(dc);
                                       swal("Ok", ">"+data, "warning")
                                      

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
function eliminar(i){


      //var array=optionArr;
    var url="../Vistas/clientes/deletecliente.php";

     
          swal({
            title: "Atención!!",
            text: "Desea Eliminar?",
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
                                 type: "POST",
                                 url: url,
                                 data: {i:i,u:su}, // Adjuntar los campos del formulario enviado.
                                            
                                 success: function(data)
                                 {
                                     
                                      clientes(dc);
                                       swal("Ok", ""+data, "success")
                                      

                                 }
                               });
                          
                        
                       }, 1000);
              });
        

}
function caracteresCorreoValido(email){
   // console.log(email);    
    var caract = new RegExp(/^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/);
    if (caract.test(email) == false){
          return false;
    }else{
          return true;
    }
}
</script>
<?php @include_once(HTML_DIR . '/template/inferior_depues_cuerpo.php'); ?>
