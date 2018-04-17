<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>

<script >

$(document).ready(function(){


});


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
      <h1>Modulo de ventas</h1>
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
              <h3 class="box-title">Lista de Pagos</h3>
              
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
            <center><h4><?=$_POST['cliente']?></h4></center>
            <div class="table-responsive" class=" col-md-12" style="padding: 20px;">
                
                <table   class="table table-bordered table-hover" id="tablajson">
                  <thead class="bg-gray">
                    <th>#</th>
                    <th>Monto</th>
                    <th>Fecha</th>
                    <th>Tipo de pago</th>
                    <th>OBS</th>
                    <th>Comprovante</th>
                  </thead>
                  <tbody>
                    <?php 
                      $idcre=$_POST['idcre'];
                      $moneda="";
                      $total=0;
                      $p = new Creditos();
                       $result=$p->get_pagosc($idcre);
                        
                        while($lista=$result->fetch_array()){  
                        $total=$total+ $lista['PC_N_ABONA'];                   
                           ?>
                           <tr id="sell<?=$lista[0]?>" >
                             <td><?php echo $lista['PC_C_CODIGO']; ?></td>                      
                             <td><?php echo $lista['MONEDA'].$lista['PC_N_ABONA'] ?></td>
                             <td><?php echo $lista['PC_F_FECHA'] ?></td>
                             <td><?php echo $lista['TPG_D_NOMBRE'] ?></td>
                             <td><?php echo $lista['PC_D_OBS'] ?></td>
                             <td><?php if ($lista['PC_I_IMG']!=""){ ?> <a href="" data-toggle="modal" data-target="#imgviewmodal" data-img="<?=$lista['PC_I_IMG']?>"   data-toggle="tooltip" title="IMAGEN">Ver Comprobante de pago</a>
                             <?php 
                             $moneda=$lista['MONEDA'];
                           } else{
                              echo "Sin comprobante";
                              } ?></td>
                             
                           </tr>
                           <?php } ?>
                  </tbody>
                  <tfoot>
                    <tr class="bg-gray">
                      <th>Total</th>
                      <th><?=$moneda?><?=number_format($total,2)?></th>
                    </tr>
                  </tfoot>
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
          <form method="POST" id="formpago"  onsubmit="pagos(); return false;">
             <center><h2 id="nombreempresa"></h2></center>
             
          <div class="form-group col-md-3">
	        <label>Monto</label>
	        <input type="text" class="form-control"  name="monto" id="monto"    required>
	      </div>
	      <div class="form-group col-md-9">
	        <label>Descripción</label>
	        <input type="text" class="form-control"  name="descripcion" id="descripcion"    required>
	        <input type="hidden"  name="idus" value="<?=$user['US_C_CODIGO'] ?>">
	        <input type="hidden"  name="idcre" >
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
<div class="modal fade" id="imgviewmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="exampleModalLabel">Comprabante de pago</h4>
      </div>
      <div class="modal-body">
          
          <div id="imgview" ></div>
            
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-secondary"  onclick="pagos(); return false;">Aceptar</button>
    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>     
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
  var cli = button.data('cli') 

   var modal = $(this)
  modal.find('.modal-title').text('Abonar a: ' + nombre)
  modal.find('input[name="idcre"]').val(id)
  

})
  $('#imgviewmodal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) 
    var img = button.data('img')
  
    var modal = $(this)
   
    modal.find('#imgview').html('<img id="imges" src="../Public/img/productos/'+img+'" alt="NO existe Comprovante" height="100%" width="100%"/>')
    
    $('#imges').show();
  
})
  
 
  </script>
 
  </script>
  
<?php include_once(HTML_DIR . '/template/inferior_depues_cuerpo.php'); ?>
