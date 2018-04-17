hola
<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>



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
              <h3 class="box-title">Lista de ventas</h3>
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

              <input id="txtbuscar" name="" type="text"  onkeyup="" class="form-control " placeholder="Search...">
                  <span class="input-group-btn">
                    <button type="submit" name="" id="" class="btn btn-flat"><i class="fa fa-search"  ></i>
                    </button>
                  </span>
              
              </div>
            
            <div class="table-responsive" class=" col-md-12" style="padding: 20px;">
                
                <table   class="table table-bordered table-hover" id="tablajson">
                  <thead class="bg-gray">
                    <th>Codigo</th>
                    <th>CLiente</th>
                    <th>RUC</th>
                    <th>Direccion</th>
                    <th>Fecha</th>
                    <th>Monto</th>
                    <th colspan="5">Op</th>
                                           
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
<div  class="modal " id="alertas" tabindex="-1" role="dialog"  >
  <div class="modal-dialog "  >
    <div class="modal-content " style="border-radius: 15px; padding: 5px 5px 5px 5px"> 
      <div class="modal-body" >
      <center><h5 id="mensaje">Error</h5></center>
      </div> 
    </div>
  </div>
</div>            <!-- /.box-body -->
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
