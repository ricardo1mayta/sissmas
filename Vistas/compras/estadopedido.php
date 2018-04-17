<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>
<?php include_once(HTML_DIR . '/template/sliderscss.php'); ?>

<?php include_once(HTML_DIR . '/template/header_menu.php'); ?>


   <div class="content-wrapper" OnLoad='compt=setTimeout("self.close();",50)'">
    <!-- Content Header (Page header) -->
    <section class="content-header">
    <?php  if(isset($sms)){ echo $sms; }?>
      <h1>Nuevo Pedido</h1>
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
              <h3 class="box-title">Datos de Productos</h3>
              <div class="box-tools pull-right">              
               <button type="button" class="btn btn-box-tool" data-toggle="modal"  ><i class="fa fa-minus"></i> </button>
                <button type="button" class="btn btn-box-tool" data-toggle="modal"><i class="fa fa-remove"></i></button>
              </div>             
            </div>
            <!-- /.box-header -->
            <form role="form" action="../registrarEmpresas/" name="form1" id="form1" method="POST" > 
            </form>
                <div class="box-body">
                 
                  <div class="row margin">
                    <div class="col-sm-6">
                      <input id="range_1" type="text" name="range_1" value="">
                    </div>

                    <div class="col-sm-6">
                      <input id="range_2" type="text" name="range_2" value="1000;100000" data-type="double" data-step="500" data-postfix=" &euro;" data-from="30000" data-to="90000" data-hasgrid="true">
                    </div>
                  </div>
                  <div class="row margin">
                    <div class="col-sm-6">
                      <input id="range_5" type="text" name="range_5" value="">
                    </div>
                    <div class="col-sm-6">
                      <input id="range_6" type="text" name="range_6" value="">
                    </div>
                  </div>
                  <div class="row margin">
                    <div class="col-sm-12">
                      <input id="range_4" type="text" name="range_4" value="10000;100000">
                    </div>
                  </div>
                 <div class="table-responsive" class=" col-md-12" style="padding: 20px;">
                     
                     <table class="table table-bordered table-hover" id="tablajson">
                      <thead class="bg-gray">
                        <th>#</th>
                        <th>CLiente</th>
                        <th>RUC</th>
                        <th>Monto</th>
                        <th>Op</th>
                                               
                      </thead>
                      <tbody>
                        <?php  $p = new Pedidos();
                         $result=$p->get_pedidos(2);
                         while($lista=$result->fetch_array()){                        
                             ?>
                             <tr>
                               <td><?php echo $lista[0] ?></td>
                               <td><?php echo $lista[1] ?></td>
                               <td><?php echo $lista[2] ?></td>
                               <td><?php echo $lista[3] ?></td>
                               <td><i class="fa fa-mail-forward" data-toggle="tooltip" title="Detalle"><i class="fa fa-arrow-circle-right" ></i></td>
  
                             </tr>
                             <?php } ?>
                      </tbody>
                      <tfoot></tfoot>
                     </table>           
                    
                    </div>
              
                  
                </div>
              </div>
             </div>
           </div>
          </div>
        </div>
        
         <!-- left column -->
        
        
        
      </div>
      <!-- /.row -->
    </section>
    <!-- /.content -->
  </div>
 
<div class="modal fade" id="alertas" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" style="rad">
  <div class="modal-dialog "  >
    <div class="modal-content " style="border-radius: 15px;" >
      <div class="modal-header  " id="h" style="border-radius: 15px 15px 0px 0px;">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">Importante!!!</h4>
      </div>
      <div class="modal-body" >
      <h3 id="mensaje">Error</h3>
      </div> 
    </div>
  </div>
</div>            <!-- /.box-body -->
 <?php include_once(HTML_DIR . '/template/footer.php'); ?>

<?php include_once(HTML_DIR . '/template/ajustes_generales.php'); ?>

<?php include_once(HTML_DIR . '/template/scrips.php'); ?>

<?php include_once(HTML_DIR . '/template/sliders.php'); ?>

<!-- Bootstrap 3.3.6 -->

<!-- DataTables -->

<script >
 $(document).ready(function() {
    setTimeout(function() {
        $("#mensage").fadeOut(1500);
    },3000);
  });
  </script>
  <script>
  $(function () {
    /* BOOTSTRAP SLIDER */
    $('.slider').slider();

    /* ION SLIDER */
    $("#range_1").ionRangeSlider({
    type: 'single',
    values: [
        'Inicio', 'PEDIDO', 'BASE DATOS',
        'FACTURACION', 'CONBRANZA'
    ],
    min: 0,
      max:5,
      from: 0,
      step: 1,
      from_percent: 0,
      from_value: 'Inicio',
      prettify: false
    });
    
   });
</script>
  
<?php include_once(HTML_DIR . '/template/inferior_depues_cuerpo.php'); ?>
