<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>

<script >

$(document).ready(function(){
cargarpedidos();

});




function finalizar(i,t,c){
  
  if (t<=c){
    var u=$('#usco').val();
   
      var url="../Vistas/creditos/finalizarcreditocompra.php";
    //$('#tablajsonp tbody').html('');
        $.ajax({
               type: "GET",
               url: url,
               data: {i:i, u:u}, // Adjuntar los campos del formulario enviado.
                          
               success: function(data)
               {
                   cargarpedidos();
                    swal("Exitó!",data,"success");

                     
               }
             });
        }
        else{
 swal("Error","Falta cancelar : "+(t-c),"warning");

        }
     
}


function cargarpedidos(){
var s=<?=$usuario['SED_C_CODIGO']?>;
   
      var url="../Vistas/creditos/creditossedecompras.php";
    //$('#tablajson tbody').html('');
        $.ajax({
               type: "GET",
               url: url,
               data: {s:s}, // Adjuntar los campos del formulario enviado.
                          
               success: function(data)
               {
                   //$("#respuesta").html(data); // Mostrar la respuestas del script PHP.
                    $('#tablajson tbody').html(data);
                  

                     
               }
             });

}
function pagos(){
var m =parseFloat( $('#monto').val());
var total = parseFloat($('#total').val());
var cancela =parseFloat( $('#cancela').val());
var tipopago =parseFloat( $('#tipopago').val());

cancela=cancela+m;
var formData= new FormData($('#formpago')[0]);
if(tipopago>0){
if(cancela<=total){


	if(m>0){

	 swal({
  title: "Atención!!",
  text: "Abonar?",
  type: "warning",
  confirmButtonText: "OK",
  cancelButtonText: "Cancelar",
  showCancelButton: true,
  closeOnConfirm: false,
  showLoaderOnConfirm: true,
},
function(){
  setTimeout(function(){
    
      var url="../Vistas/creditos/abonarcompras.php";
    

     $.ajax({
                                type: 'POST',
                                url: url,
                                data: formData,
                                contentType: false,
                                processData: false,
                                success: function(data){
                                 $('#myModalpagos').modal('toggle');
                                 $('#monto').html('');
                                 $('#descripcion').html('');
                                  cargarpedidos();
                                 swal("Pago Registrado: "+data);
                                }
                              });
  });
});

}
else
{
 swal("Falta El monto: ",'o el monto es mayor al total',"warning");	
}
}else
{
 swal("Monto SUperado: ",'Revisar el total',"warning"); 
}
}else{
  swal("Seleccionar: ",'el tipo de pago',"warning");
}
}
function credito(t){
swal({
  title: "Atención!!",
  text: "Crear Credito?",
  type: "warning",
  confirmButtonText: "OK",
  cancelButtonText: "Cancelar",
  showCancelButton: true,
  closeOnConfirm: false,
  showLoaderOnConfirm: true,
},
function(){
  setTimeout(function(){
    var s=<?=$usuario['US_C_CODIGO']?>;
   
      var url="../Vistas/cobranzas/creditocompras.php";
    
        $.ajax({
               type: "GET",
               url: url,
               data: {s:s,t:t}, // Adjuntar los campos del formulario enviado.
                          
               success: function(data)
               {
                   
                    
                  		cargarpedidos();
                     swal("Pago Registrado: "+data);

                     
               }
             });
    
  });
});

}
function imprimir(hr,op){
	if(op=='F'){
  var url='../Vistas/cobranzas/imprimirf.php?q='+hr;
 }
 if(op=='B'){
  var url='../Vistas/cobranzas/imprimirb.php?q='+hr;
 }
 if(op=='P'){
  var url='../Vistas/cobranzas/imprimirp.php?q='+hr;
 }

      var posicion_x; 
      var posicion_y; 
      posicion_x=(screen.width/2)-(800/2); 
      posicion_y=(screen.height/2)-(700/2); 

          var caracteristicas = "height=700,width=800,scrollTo,resizable=1,scrollbars=1,location=0,left="+posicion_x+",top="+posicion_y+"";
          window.open(url, 'Popup', caracteristicas);
          
}


</script>
<?php include_once(HTML_DIR . '/template/header_menu.php'); ?>


   <div class="content-wrapper" OnLoad='compt=setTimeout("self.close();",50)'">
    <!-- Content Header (Page header) -->
    <section class="content-header">
    <?php  if(isset($sms)){ echo $sms; }?>
      <h1>Modulo de Creditos</h1>
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
              <h3 class="box-title">Lista de Cuentas Por Pagar</h3>
              
              <div class="box-tools pull-right">              
               <button type="button" class="btn btn-box-tool" data-toggle="modal"  ><i class="fa fa-minus"></i> </button>
                <button type="button" class="btn btn-box-tool" data-toggle="modal"><i class="fa fa-remove"></i></button>
              </div>             
            </div>
            <div class="box-body">
            <div class="row">
        <div class="col-md-12">
          <!-- Custom Tabs -->
          <div class="nav-tabs-custom">
            
            <div class="table-responsive" class=" col-md-12" style="padding: 20px;">
                
                <table   class="table table-bordered table-hover" id="tablajson">
                  <thead class="bg-gray">
                    <th>#</th>
                    <th>Proveedor</th>
                    <th>Cuenta Total</th>
                    <th>Suma De Pagos</th>
                    <th>Fecha</th>
                     <th>Estado</th>                    
                    <th colspan="4">Op</th>                                           
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
<div class="modal fade" id="myModalpagos" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="exampleModalLabel">Abonar</h4>
      </div>
      <div class="modal-body">
          <form method="POST" id="formpago"  onsubmit="pagos(); return false;" enctype="multipart/form-data">
            
             
          <div class="form-group ">
  	        <label>Monto</label>
  	        <input type="text" class="form-control"  name="monto" id="monto"    required>
  	      </div>          
          <div class="form-group ">
              
               <input id="tipomoneda" name="tipomoneda" type="text"  class="form-control " readonly>
                              
              </select>
          </div>
          <div class=" ">

            <div class="form-group">
            <label>Moneda</label>
                <input id="tipocambio" name="tipocambio" type="text"  class="form-control " placeholder="0.00" autofocus>
            </div>
          </div>
          
  	      <div class="form-group ">
  	        <label>Descripción</label>
  	        <textarea class="form-control"  name="descripcion" id="descripcion"    required></textarea> 
  	        <input type="hidden"  name="idus" value="<?=$user['US_C_CODIGO'] ?>">
  	        <input type="hidden"  name="idcre" >
             <input type="hidden"  name="total" id="total">
             <input type="hidden"  name="cancela" id="cancela">
  	      </div>
          <div class="form-group">
            <label>Tipo de pago</label>
            <select class="form-control" id="tipopago" name="tipopago">
            <option value="0">Seleccione</option>
              <?php $p = new Tipopagos();
                $result=$p->get_alltipopagos();
                
                while($lista=$result->fetch_array()){ ?>
                <option value="<?=$lista[0]?>"><?=$lista[1]?></option>
                <?php
                }?>
            </select>
          </div>
          <div class="form-group ">

            <label for="exampleInputFile">Boucher</label>
            <input  type="file" id="files" class="filestyle" name="img"/>
          
          </div>
          
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-secondary"  onclick="pagos(); return false;">Aceptar</button>
		  <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>     
    </div>
    </form>
    </div>
  </div>
</div> 
<div  class="modal " id="alertas" tabindex="-1" role="dialog"  >
  <div class="modal-dialog "  >
    <div class="modal-content " style="border-radius: 15px; padding: 5px 5px 5px 5px"> 
      <div class="modal-body" >
      <center><h5 id="mensaje">Error</h5></center>
      </div> 
    </div>
  </div>
</div>
     <!-- /.box-body -->
 <?php include_once(HTML_DIR . '/template/footer.php'); ?>

<?php include_once(HTML_DIR . '/template/ajustes_generales.php'); ?>

<?php include_once(HTML_DIR . '/template/scrips.php'); ?>


<!-- Bootstrap 3.3.6 -->

<!-- DataTables -->

<script >
 $(document).ready(function() {
    setTimeout(function() {
        $("#mensage").fadeOut(1500);
    },3000);
  });

  $('#myModalpagos').on('show.bs.modal', function (event) {
  var button = $(event.relatedTarget) 
  var id = button.data('id')
  var nombre = button.data('nom') 
   var tot = button.data('total')
   var can = button.data('cancela')
  var cli = button.data('cli') 
  var mon=button.data('moneda')

   var modal = $(this)
  modal.find('.modal-title').text('Abonar a: ' + nombre)
  modal.find('input[name="idcre"]').val(id)
  modal.find('input[name="total"]').val(tot)
  modal.find('input[name="cancela"]').val(can)
  modal.find('input[name="monto"]').val('');
  modal.find('input[name="descripcion"]').val('');
  modal.find('input[name="files"]').val('');
  modal.find('input[name="tipomoneda"]').val(mon);
  
   $('#tipopago').prop('selectedIndex',0);

    if(mon=="Dolares"){
      $("#tipocambio").show();
    }else{
       $("#tipocambio").hide();
    }

})

  
 
  </script>
 
  </script>
  
<?php include_once(HTML_DIR . '/template/inferior_depues_cuerpo.php'); ?>
