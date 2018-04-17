<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/permisos.php"); //echo "us".$_GET['id']." vis:".$_GET['id2']; 



                 $idus=$_GET['id'];
                 $idvis=$_GET['id2'];
                 
                 $per = new Permisos();

                      if($ms=$per->save_permiso($idus,$idvis)){
                        $m=$ms->fetch_array();
                    echo "si".$m['sms'];
                  ?>

                 <ul class="treeview-menu">
                 
                      <?php
                          $per1 = new Permisos();

                         $result=$per1->user_menu1($idus,0);
                         while($lista=$result->fetch_array()){                        
                             ?>
                          
                            <li class=" "><?php echo  $lista['VIS_D_NOMBRE'];?></li>
                            
                              <?php  $per2 = new Permisos();
                              $html=$per2->user_sub_menu1($idus,$lista['VIS_C_CODIGO']);

                              echo $html;
                             
                            ?>

                  <?php 
                    }
                  } else
                  {
                    $m=$ms->fetch_array();
                    echo "fallo".$m['sms'];
                  }
                  ?>
                 </ul>
                