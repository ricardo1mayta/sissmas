<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>
<?php include_once(HTML_DIR . '/template/header_menu.php'); ?>
<?php  

   ?>
  <div class="content-wrapper" >
	  <div class="content">
	  	
        <div class="box">
        <div class="box-header with-border">
          <h3 class="box-title">Usuario: <?php echo $nombre." ".$apell;?></h3>

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
          <div class="box box-warning ">
           
            
             

              <!-- /.box-header -->
              <form role="form" name="form1" id="form1" action="" method="POST" >
                  <div class="box-body" >

                     <?php 
                        $indice=1;
                        $vistas = new Vistas();
                         $result=$vistas->get_allvistas(0);
                         while($lista=$result->fetch_array()){                        
                             ?>
                                 
                          <ul>
                           
                              <li >
                               <a onclick="from2(<?php echo $codigo ?>, <?php echo $lista[0] ?>,'view','../Vistas/vistas/ajaxAgregar.php')"><?php echo $lista[1]?></a>
                               
                               
                              </li>
                               <?php $vistas->get_allSubvistas($lista[0],$codigo);
                            
                                ?>
                              
                            
                           
                          </ul>
                     
                  <?php 
                    }
                  ?>
               </div>
              </form>
           
           </div>
          <!-- /.box -->
        </div>
        <div class="box-body">
          <?php   if(isset($sms)) { echo $sms; $sms="";}?>
          <div class="col-md-12">
                    
          <!-- general form elements disabled -->
          <div class="box box-warning sombra">
            <div class="box-header with-border">
              <h3 class="box-title"> Vistas Asigandas al usuario </h3>
            </div>
            <div class="box-body" id="view">
             

                 <ul >
                 <?php 
                        $indice=1;
                        $per = new Permisos();
                         $result=$per->user_menu1($codigo,0);
                         while($lista=$result->fetch_array()){                        
                             ?>
                         
                            <li class=""><?php echo  $lista['VIS_D_NOMBRE'];?></li>
                            
                              <?php  
                              $html=$per->user_sub_menu1($codigo,$lista['VIS_C_CODIGO']);

                              echo $html;?>
                            

                  <?php 
                    }
                  ?>
                 </ul>
                
             
                
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

