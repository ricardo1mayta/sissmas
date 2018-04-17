<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>

<script >

$(document).ready(function(){
//cargarcompras('F');

});

function buscar(c){

  var txt=$('#txtbuscar').val();
    var s=$('#idsed').val();
    
    var url="../Vistas/reportes/busquedaproductocomprado.php";
if(txt!=''){
  $(c).keypress(function(e) {
    if(e.which == 13) {
    
  
  
    
       
        $.ajax({
               type: "POST",
               url: url,
               data: {txt:txt, s:s}, // Adjuntar los campos del formulario enviado.
                          
               success: function(data)
               {
                   //$("#respuesta").html(data); // Mostrar la respuestas del script PHP.
                    $('#tablajson tbody').html(data);
                  

               }
             });
           }
  });
   
 } else {
       $('#tablajson tbody').html('');
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
              <h3 class="box-title">Busqueda Del producto comprado por codigo de Barras</h3>
              <input type="hidden" id="idsed" value="<?=$user['SED_C_CODIGO'] ?>">
             
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
                     <th>Codigo-Serie-Co_Barra</th>
                    <th>Provedor</th>
                    <th>Fecha</th>
                    <th>Estado</th>
                                           
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

  
 
  </script>
 
  </script>
  
<?php include_once(HTML_DIR . '/template/inferior_depues_cuerpo.php'); ?>
