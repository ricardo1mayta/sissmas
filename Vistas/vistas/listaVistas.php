<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>
<?php include_once(HTML_DIR . '/template/header_menu.php'); ?>
<?php  

   ?>
  <div class="content-wrapper" >
	  <div class="content">
	  	
        <div class="box">
        <div class="box-header with-border">
          <h3 class="box-title">Lista de Usuarios<?php //echo $nomp ?></h3>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip" title="Collapse">
              <i class="fa fa-minus"></i></button>
            <button type="button" class="btn btn-box-tool" data-widget="remove" data-toggle="tooltip" title="Remove">
              <i class="fa fa-times"></i></button>
          </div>
        </div>
        <div class="box-body">
          <?php   if(isset($sms)) { echo $sms; $sms="";}?>
          <div class="col-md-12">
                      
          <!-- general form elements disabled -->
          <div class="box box-warning sombra">
            <div class="box-header with-border">
              <h3 class="box-title">Detalle de Secciones </h3>
            </div>
            <div class="box-body">
                <table  class="table ">
                <thead>
                <tr>
                  
                  
                  <th>CODIGO</th>
                  <th>NOMBRE</th>
                  <th>ENLACE</th>
                  <th>PADRE</th>
                 
                  <th>ICONO</th>
                   
                </tr>
                </thead>
                <tbody>
                 <?php 
                        $indice=1;
                        $vistas = new Vistas();
                         $result=$vistas->get_allvistas(0);
                         while($lista=$result->fetch_array()){                        
                             ?>
                                 
                          <tr class="padre">
                            <td><?php echo  $lista[0];?></td>
                            
                            <td><?php echo $lista[1]?></td>
                            <td><?php echo $lista[2]?></td>
                            <td><?php echo $lista[3]?></td>
                            <td><?php echo $lista[4]?></td>
                           
                          </tr>
                          <?php $vistas->get_allSubvistas($lista[0],$lista[0]);
                           $indice++;
                          ?>
                       

                  <?php 
                    }
                  ?>
                
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
<?php @include_once(HTML_DIR . '/template/ajustes_generales.php'); ?>
<?php @include_once(HTML_DIR . '/template/scrips.php'); ?>
<?php @include_once(HTML_DIR . '/template/inferior_depues_cuerpo.php'); ?>
