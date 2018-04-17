<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>
<?php include_once(HTML_DIR . '/template/header_menu.php'); ?>
<?php  

   ?>
  <div class="content-wrapper" >
	  <div class="content">
	  	<?php   include(HTML_DIR .'usuarios/opcionesUsuarios.php');?>
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
                  <th>APELLIDOS</th>
                  <th>CORREO</th>
                 
                  <th>EMPRESA</th>
                   
                </tr>
                </thead>
                <tbody>
                 <?php 
                        $user = new User();
                         $result=$user->lista_usuarios();
                         while($lista=$result->fetch_array()){                        
                             ?>
                             
                      <tr>
                        <td><?php echo $lista['US_C_CODIGO']?></td>
                        <td><?php echo $lista['US_D_NOMBRE']?></td>
                        <td><?php echo $lista['US_D_APELL']?></td>
                        <td><?php echo $lista['US_C_CORREO']?></td>
                        <td><?php echo $lista['SED_D_NOMBRE']?></td>
                         <td>
                          <form action="../listarUsuarios/"  method="post">
                            <input type="hidden" value="eliminar" name="evento">
                            <input type="hidden" value="<?php echo $lista['US_C_CODIGO']?>" name="id">
                            <input type="submit"  class='btn btn-warning'  value="Eliminar">
                          </form>
                                             
                        </td>
                        <td>
                          <form action="../listarUsuarios/"  method="post">
                            <input type="hidden" value="modificar" name="evento">
                            <input type="hidden" value="<?php echo $lista['US_C_CODIGO']?>" name="codigo">
                            <input type="hidden" value="<?php echo $lista['US_D_NOMBRE']?>" name="nombre">
                            <input type="hidden" value="<?php echo $lista['US_D_APELL']?>" name="apell">
                            <input type="hidden" value="<?php echo $lista['US_C_CORREO']?>" name="correo">
                            <input type="hidden" value="<?php echo $lista['US_P_PASSWORD']?>" name="pass">
                            <input type="hidden" value="<?php echo $lista['SED_D_NOMBRE']?>" name="sede">
                            <input type="hidden" value="<?php echo $lista['SED_C_CODIGO']?>" name="idsede">
                            <input type="hidden" value="<?php echo $lista['US_I_IMAGEN']?>" name="img">
                            <input type="submit"  class='btn btn-warning'  value="Modificar">
                          </form>
                                             
                        </td>
                         <td>
                          <form action="../listarUsuarios/"  method="post">
                            <input type="hidden" value="vistas" name="evento">
                            <input type="hidden" value="<?php echo $lista['US_C_CODIGO']?>" name="id">
                            <input type="hidden" value="<?php echo $lista['US_D_NOMBRE']?>" name="nombre">
                            <input type="hidden" value="<?php echo $lista['US_D_APELL']?>" name="apell">
                            <input type="submit"  class='btn btn-warning'  value="Vistas">
                          </form>
                                             
                        </td>
                        
                      </tr>
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
