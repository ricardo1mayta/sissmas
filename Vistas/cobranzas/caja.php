<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>

<script >

$(document).ready(function(){
cargarpedidos('F');

});

var fila=0;
var auxfila=0;
var pedido=0;
 

function verdetallepedido(p,f,n){
  pedido=p;
  $("#sell"+fila).removeClass('bg-yellow');
  var nn='00000000'+p;
  var texto='PED-'+nn.substr(nn.length - 8)+'<br>'+n;
  $("#nombreempresa").html(texto);
  auxfila=fila;
   fila=f;
    var user=$('#usco').val();
   
      var url="../Vistas/cobranzas/detalleventas.php";
    //$('#tablajsonp tbody').html('');
        $.ajax({
               type: "GET",
               url: url,
               data: {txt:p, u:user}, // Adjuntar los campos del formulario enviado.
                          
               success: function(data)
               {
                   //$("#respuesta").html(data); // Mostrar la respuestas del script PHP.
                    $('#tablajsonp tbody').html(data);

                  $("#sell"+fila).addClass('bg-yellow');

                     
               }
             });
     
}


function anular(id){

 swal({
  title: "Atención!!",
  text: "Desea Anular?",
  type: "warning",
  confirmButtonText: "OK",
  cancelButtonText: "Cancelar",
  showCancelButton: true,
  closeOnConfirm: false,
  showLoaderOnConfirm: true,
},
function(){
  setTimeout(function(){
    var user=$('#usco').val();
   
      var url="../Vistas/ventas/anularventa.php";
    
        $.ajax({
               type: "GET",
               url: url,
               data: {txt:id, u:user},
               success: function(data)
               {
                     cargarpedidos('F');
                     swal("Anulado: "+data);

                  
                     
               }
             });
    
  });
});
}

function cargarpedidos(t){
var s=<?=$usuario['SED_C_CODIGO']?>;
   
      var url="../Vistas/cobranzas/ventassede.php";
    //$('#tablajson tbody').html('');
        $.ajax({
               type: "GET",
               url: url,
               data: {s:s,t:t}, // Adjuntar los campos del formulario enviado.
                          
               success: function(data)
               {
                   //$("#respuesta").html(data); // Mostrar la respuestas del script PHP.
                    $('#tablajson tbody').html(data);
                  

                     
               }
             });

}
function cobrar(){
var tipopago =parseFloat( $('#tipopagos').val());
if(tipopago>0){
	 swal({
  title: "Atención!!",
  text: "Cobrar?",
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
    var t=parseFloat($("#idventac").val());
   
      var url="../Vistas/cobranzas/cobrar.php";
    
        $.ajax({
               type: "GET",
               url: url,
               data: {s:s,t:t,tp:tipopago}, // Adjuntar los campos del formulario enviado.
                          
               success: function(data)
               {
                   
                    
                  		cargarpedidos('F');
                      $('#tipopago').modal('toggle');
                     swal("Pago Registrado: "+data+t);


                     
               }
             });
    
  });
});

}else{
  swal("Seleccionar: ",'el tipo de pago'+tipopago,"warning");
}
}
function credito(){
 var t = $("#idventacc").val();
   var fv =$("#fvence").val();
   if(fv!=""){
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
   
  
   
      var url="../Vistas/cobranzas/credito.php";
    
        $.ajax({
               type: "GET",
               url: url,
               data: {s:s,t:t,fv:fv}, // Adjuntar los campos del formulario enviado.
                          
               success: function(data)
               {
                   
                    
                  		cargarpedidos('F');
                        $('#acredito').modal('toggle');
                     swal("Pago Registrado: "+data);


                     
               }
             });
    
  });
});
} else
{
 swal("Error: Falta Fecha Maxima de Credito");


}
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
    
      <h1>Modulo de Cobranza</h1>
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
              <h3 class="box-title">Lista de ventas</h3>
              
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
            <ul class="nav nav-tabs">
              <li class="active"><a href="#tab_1" data-toggle="tab" onclick="cargarpedidos('F')">FACTURAS</a></li>
              <li><a href="#tab_2" data-toggle="tab" onclick="cargarpedidos('B')">BOLETAS</a></li>
              <li><a href="#tab_3" data-toggle="tab" onclick="cargarpedidos('P')">PROFORMA</a></li>
              
             
            </ul>
            <div class="table-responsive" class=" col-md-12" style="padding: 20px;">
                
                <table   class="table table-bordered table-hover" id="tablajson">
                  <thead class="bg-gray">
                    <th>#</th>
                    <th>CLiente</th>
                    <th>RUC</th>
                    <th>Direccion</th>
                    <th>Fecha</th>
                    <th>Monto</th>
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
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
       
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
          
             <center><h2 id="nombreempresa"></h2></center>
              <div class="table-responsive" class=" col-md-12" style="padding: 20px;">
                 
                 <table class="table table-bordered table-hover" id="tablajsonp">
                  <thead class="bg-gray">
                    <th>#</th>
                    <th>Productos</th>
                    <th>Cantidad</th>
                    <th>Precio</th>
                    <th>Sub-Total</th>
                    <th >OP</th>
                                           
                  </thead>
                  <tbody>
                    
                  </tbody>
                  <tfoot></tfoot>
                 </table>           
                
              </div>
          
            
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        
      </div>
    </div>
  </div>
</div> 
<div  class="modal " id="tipopago" tabindex="-1" role="dialog"  >
  <div class="modal-dialog "  >
    <div class="modal-content " > 
      <div class="modal-body" >
      <div class="form-group ">
            <label>Tipo de pago</label>
            <select class="form-control" id="tipopagos" name="tipopagos">
            <option value="0">Seleccione</option>
              <?php $p = new Tipopagos();
                $result=$p->get_alltipopagos();
                
                while($lista=$result->fetch_array()){ ?>
                <option value="<?=$lista[0]?>"><?=$lista[1]?></option>
                <?php
                }?>
            </select>
          </div>
          <div class="modal-footer">
          <input id="idventac"  type="hidden" name="idventac">
        <button type="submit" class="btn btn-secondary"  onclick="cobrar(); return false;">Aceptar</button>
      <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>     
    </div>
      </div> 
    </div>
  </div>
</div>      
<div  class="modal " id="acredito" tabindex="-1" role="dialog"  >
  <div class="modal-dialog "  >
    <div class="modal-content " > 
    <div class="modal-header">
       <h2>Fecha de vencimiento del Credito</h2>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" >
      <div class="form-group ">
            <input type="date" class="form-control" name="fvence" id="fvence">
          </div>
          <div class="modal-footer">
          <input id="idventacc"  type="hidden" name="idventacc">
        <button type="submit" class="btn btn-secondary"  onclick="credito(); return false;">Aceptar</button>
      <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>     
    </div>
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

  $('#myModal').on('show.bs.modal', function (event) {
  var button = $(event.relatedTarget) 
  var id = button.data('id')
  var nombre = button.data('nom') 

  verdetallepedido(id,id,nombre);
 
})

  $('#tipopago').on('show.bs.modal', function (event) {
  var button = $(event.relatedTarget) 
  var id = button.data('id')
  var nombre = button.data('nom') 

  var modal = $(this)
  modal.find('.modal-title').text('Abonar a: ' + nombre)
  modal.find('input[name="idventac"]').val(id)
  modal.find('input[name="nombre"]').val(nombre)
  $('#tipopagos').prop('selectedIndex',0);
 
})
   $('#acredito').on('show.bs.modal', function (event) {
  var button = $(event.relatedTarget) 
  var id = button.data('id')
  var nombre = button.data('nom') 

  var modal = $(this)
  modal.find('.modal-title').text('Abonar a: ' + nombre)
  modal.find('input[name="idventacc"]').val(id)
  modal.find('input[name="nombre"]').val(nombre) 
})

  
 
  </script>
 
  </script>
  
<?php include_once(HTML_DIR . '/template/inferior_depues_cuerpo.php'); ?>
