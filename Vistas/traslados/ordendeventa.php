<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>

<script >

$(document).ready(function(){
buscar();
$('#resul').hide();
$('#resulcliente').hide();
$('[data-toggle="tooltip"]').tooltip();
var optionArr=[];

});
var con=0;
/*optionArr=[{"id":1, "name":"abc","cantidad":2,"precio":15},
{"id":2,"name":"paginas","cantidad":2,"precio":15},
{"id":3,"name":"cuatorx","cantidad":2,"precio":15}];*/

 function buscar(){
    var txt=$('#txtbuscar').val();
    var s=$('#idsed').val();
    $('#resul').show(); 
    var url="../Vistas/pedidos/listaproductos.php";
  
  
    if(txt!=''){
        $('#resul').html('');
        $.ajax({
               type: "GET",
               url: url,
               data: {txt: txt,s:s}, // Adjuntar los campos del formulario enviado.
                          
               success: function(data)
               {
                   //$("#respuesta").html(data); // Mostrar la respuestas del script PHP.
                    $('#resul').html(data);
                  

               }
             });
      } else {
        $('#resul').html('');
        $('#resul').hide(); 
      }
  
 
}

function agregar(idpro,can,pre,pv,nom){
  var nomb=$(nom).text();
  
    $('#txtbuscar').val('');
    
    buscar();
    //alert(con);
    if(con == 0){
      optionArr=[{"id":idpro,"name":nomb,"cantidad":1,"precio":pv,"cantidad2":can,"precio2":pre}];
      
    } else{
    agre(idpro,nomb,can,pre,pv);
    
    
    } 
    con++;
    add();
}
function agregar_c(idemp,ruc,nom,direccion){
  
    //alert(nom);
    $('#idemp').val(idemp); 
    $('#nombre_c').val(nom); 
    $('#direccion').val(direccion);
    $('#ruc').val(ruc);
    $('#ruc').addClass('bg-gray'); 
    $('#direccion').addClass('bg-gray');
    $('#nombre_c').addClass('bg-gray');
    $('#txt_cliente').val('');

    buscarcliente();
    

}
function buscarcliente(){
    var txt=$('#txt_cliente').val();
    var idsed=$('#idsed').val();
   $('#resulcliente').show(); 
      var url="../Vistas/traslados/listarclientes.php";
    
    
    if(txt!=''){
        $('#resulcliente').html('');
        $.ajax({
               type: "GET",
               url: url,
               data: {txt: txt, s:idsed}, // Adjuntar los campos del formulario enviado.
                          
               success: function(data)
               {
                   
                    $('#resulcliente').html(data);
                  

               }
             });
      } else {
        $('#resulcliente').html('');
        $('#resulcliente').hide(); 
      }
    
   
}

function add(){
//optionArr.push({"id":4,"name":"test","cantidad":5,"precio":67});



  $('#tablajson tbody').html(" ");
  for(var i=0; i< optionArr.length; i++) {
    var row='<tr>'
        +'<td>'+parseInt(i+1)+'</td>'
        +'<td>'+optionArr[i]['id']+'</td>'
        +'<td>'+optionArr[i]['name']+'</td>'
        +'<td><input type="text" style="width:70px"  onkeyup="edit_c('+i+',this)" value="'+optionArr[i]['cantidad']+'"></td>'
        +'<td><span>$. </span><span><input type="text" style="width:90px" onkeyup="edit_p('+i+',this)" value="'+optionArr[i]['precio']+'"></span></td>'
        +'<td ><span>$. '+((parseFloat(optionArr[i]['cantidad']))*(parseFloat(optionArr[i]['precio']))).toFixed(2)+'</span></td>'
        +'<td><i class=" fa fa-close pull-right text-red" style="cursor: pointer" onclick="delterow('+i+')" data-toggle="tooltip" title="Eliminar"></i></td>'
        
        +'</tr>';
    $(row).appendTo("#tablajson tbody");
  }

  var total=0;
  for(var i=0; i< optionArr.length; i++) {
    total=(parseFloat(optionArr[i]['cantidad']))*(parseFloat(optionArr[i]['precio']))+total;
    
    
  }
  $('#tablajson tfoot').html(" ");
  var row='<tr>'
        +'<th colspan="5"><label class="pull-right">TOTAL :</label></th>'
        +'<th colspan="2" class="bg-gray"><span>$. </span>'+total.toFixed(2)+'</th>'
        +'</tr>';
  $(row).appendTo("#tablajson tfoot");

}
function edit_c(i,c){
  $(c).keypress(function(e) {
    if(e.which == 13) {
        var ca=$(c).val();
        if(ca>optionArr[i].cantidad2){
           
           swal("Fallo!", "Cantidad Maxima "+optionArr[i].cantidad2, "error");
        } else {
          optionArr[i].cantidad = ca;
           //swal("OK!", "Cantidad Maxima "+optionArr[i].cantidad2, "success");
        }
        add();
      $(c).focus();
    }
});
  
}
function edit_p(i,c){
  $(c).keypress(function(e) {
    if(e.which == 13) {
        var ca=$(c).val();
        if(ca<optionArr[i].precio2){
           
           swal("Fallo!", "Precio Minimo "+optionArr[i].precio2, "error");
        } else {
          optionArr[i].precio = ca;
           //swal("OK!", "Cantidad Maxima "+optionArr[i].cantidad2, "success");
        }

      
      add();
      $(c).focus();
    }
});
  
}
function delterow(i){
 
 optionArr.splice(i,1);
  add();
}
function agre(id,name,can,pre,pv){
  
  var a = 0;
  for (var i = 0; i < optionArr.length; i++) {
    if (optionArr[i].id === id) {
      if(optionArr[i].cantidad>=optionArr[i].cantidad2){
           
           swal("Fallo!", "Cantidad Maxima "+optionArr[i].cantidad2, "error");
        } else{
       optionArr[i].cantidad = parseInt(optionArr[i].cantidad)+1;
      
     }
        a=1;
    }
    
  }
  
  add();
  
  if (a == 0) {
      optionArr.push({"id":id,"name":name,"cantidad":1,"precio":pv,"cantidad2":can,"precio2":pre});  
  }  
  
}
function cancelar(){

   optionArr=[];
    add();
    con=0;
    $('#tablajson tfoot').html(" ");
    $('#contacto').html(' <option value="0">Selecione Contacto</option>');
}
function guardar(){

     
       var idemp=$("#idemp").val();
      var us=$("#usco").val();
      var s=$("#idsed").val();
      //var array=optionArr;
    var url="../Vistas/traslados/pedidos.php";

      if(idemp>0  ){
        if( con>0){
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
                          $('#respuesta').html('');
                          
                          $.ajax({
                                 type: "POST",
                                 url: url,
                                 data: {idemp: idemp, u:us,ar:optionArr,s:s}, // Adjuntar los campos del formulario enviado.
                                            
                                 success: function(data)
                                 {
                                     
                                      cancelar();
                                      $('#idemp').val(''); 
                                      $('#nombre_c').val(''); 
                                      $('#direccion').val('');
                                      $('#ruc').val('');
                                      $('#ruc').removeClass('bg-gray'); 
                                      $('#direccion').removeClass('bg-gray');
                                      $('#nombre_c').removeClass('bg-gray');
                                      $('#txt_cliente').val('');
                                       swal("Ok", "Gruardado Correctamente"+data, "success")
                                      

                                 }
                               });
                          
                        
                       }, 1000);
              });
          } else{
                  swal("Falta Agregar Productos ");
          }
          } else {
                  swal("Falta Agregar Usuario ");
                  }
        
     

}

</script>
<?php include_once(HTML_DIR . '/template/header_menu.php'); ?>


   <div class="content-wrapper" OnLoad='compt=setTimeout("self.close();",50)'">
    <!-- Content Header (Page header) -->
    <section class="content-header">
    <?php  if(isset($sms)){ echo $sms; }?>
      <h1>Nueva Orden de Venta</h1>
     <input type="hidden" id="usco" value="<?=$user['US_C_CODIGO'] ?>">
      <input type="hidden" id="idsed" value="<?=$usuario['SED_C_CODIGO']?>">
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
              <h3 class="box-title">Información</h3>
              <div class="box-tools pull-right">              
               <button type="button" class="btn btn-box-tool" data-toggle="modal"  ><i class="fa fa-minus"></i> </button>
                <button type="button" class="btn btn-box-tool" data-toggle="modal"><i class="fa fa-remove"></i></button>
              </div>             
            </div>
            <!-- /.box-header -->
            <form role="form" action="../registrarEmpresas/" name="form1" id="form1" method="POST" > 
            </form>
                <div class="box-body">
                  <div class="col-md-12">
                    <div class="panel panel-default  ">
                      <div class="panel-heading ">Detalles de la orden de venta</div>
                      <div class="panel-body">
                        <div class="col-md-12">
                          <div class=" col-md-3">
                          <label>Busqueda por Nombre:</label>
                          <div  class="input-group col-md-12">

                            <input id="txt_cliente" name="" type="text"  onkeyup="buscarcliente()" class="form-control " placeholder="Search..." autofocus>
                                <span class="input-group-btn">
                                  <button type="submit" name="" id="" onclick="buscarcliente()" class="btn btn-flat"><i class="fa fa-search"  ></i>
                                  </button>
                                </span>
                            
                            </div>
                            <div id="resulcliente" style="z-index: 1000;position:absolute;margin-top:0px;" class="panel bg-green" >
                            </div>
                          </div>
                         
                            <input type="hidden" class="form-control" id="ruc" placeholder="RUC">
                          
                          <div class="form-group col-md-3">
                          <label>Usuario</label>
                            <input type="text" class="form-control" id="nombre_c" placeholder="Nombre Cliente">
                          </div>
                          <div class="form-group col-md-4">
                          <label>Alamacen:</label>
                            <input type="text" class="form-control" id="direccion" placeholder="Direccion">
                          </div>
                         

                          
                          
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  <div class="col-md-12">
                    <div class="panel panel-default  ">
                      <div class="panel-heading bg-warnig">Lista de  Pedidos</div>
                      <div class="panel-body">
                        <div class="col-md-12">
                          <div class=" col-md-4">
                            <div  class="input-group col-md-12">
                            <input id="txtbuscar" name="terminos" type="text"  onkeyup="buscar()" class="form-control " placeholder="Search..." autofocus>
                                <span class="input-group-btn">
                                  <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"  onclick="buscar()"></i>
                                  </button>
                                </span>
                            
                            </div>
                            <div id="resul" style="z-index: 1000;position:absolute;margin-top:0px;" class="panel bg-green" >
                            </div>

                          </div>
                          
                          
                          
                        </div>
                      
                    
                  
                    <div class="col-md-12">
                    <div class="table-responsive" class=" col-md-12" style="padding: 20px;">
                     
                     <table class="table table-bordered table-hover" id="tablajson">
                      <thead>
                        <th>#</th>
                        <th>Id</th>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>Precio V</th> 
                        <th colspan="2">Sub Total</th>
                      </thead>
                      <tbody></tbody>
                      <tfoot></tfoot>
                     </table>           
                    
                    </div>
                    <div class="box-tools pull-right">
                     <div class="form-group ">
                        <input type="button" class="btn btn-success"  value="Guardar" onclick="guardar()">
                        <input type="button" class="btn btn-danger"  value="Cancelar" onclick="cancelar()">
                      </div>
                      
                    </div>

                    <div id="respuesta"></div>
                </div>
              </div>
             </div>
           </div>
          </div>
        </div>
      </div>
      <!-- /.row -->
    </section>
    <!-- /.content -->
  </div>
 
         <!-- /.box-body -->
 <?php include_once(HTML_DIR . '/template/footer.php'); ?>

<?php include_once(HTML_DIR . '/template/ajustes_generales.php'); ?>

<?php include_once(HTML_DIR . '/template/scrips.php'); ?>


<!-- Bootstrap 3.3.6 -->

<!-- DataTables -->

  
<?php include_once(HTML_DIR . '/template/inferior_depues_cuerpo.php'); ?>
